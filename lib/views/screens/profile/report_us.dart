import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../controllers/auth_controller.dart';
import '../../../models/booking/booking_info_model.dart';
import '../../../services/constants.dart';

class ReportIssuePage extends StatefulWidget {
  final List<BookingInfo> bookings;
  const ReportIssuePage({super.key, required this.bookings});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  String? selectedBooking;
  String? selectedIssueType;
  final TextEditingController descriptionController = TextEditingController();
  List<File> selectedFiles = [];
  bool _isSubmitting = false;

  final AuthController authController = Get.find<AuthController>();

  // Example Issue Types (replace with API list if needed)
  final List<String> issueTypes = [
    "Payment Issue",
    "Service Issue",
    "Booking Change",
    "Other",
  ];

  Future<void> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      final files = result.paths.map((path) => File(path!)).toList();
      setState(() => selectedFiles.addAll(files));
    }
  }

  void removeImage(int index) {
    setState(() => selectedFiles.removeAt(index));
  }

  Future<void> submitReport() async {
    if (_isSubmitting) return;

    if (selectedBooking == null ||
        selectedIssueType == null ||
        descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final token = authController.getUserToken();
    if (token.isEmpty) {
      Get.snackbar("Error", "You must be logged in to submit a report.");
      setState(() => _isSubmitting = false);
      return;
    }

    final uri = Uri.parse(
      '${AppConstants.baseUrl}${AppConstants.addSupportTicket}',
    );

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['booking_id'] = selectedBooking!
      ..fields['issue_type'] = selectedIssueType!
      ..fields['description'] = descriptionController.text;

    // Attach all selected files
    for (var file in selectedFiles) {
      final fileName = file.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath(
        'reference_image[]', // use array if backend supports multiple
        file.path,
        filename: fileName,
      ));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Issue reported successfully!')),
          );
          setState(() {
            selectedFiles.clear();
            selectedBooking = null;
            selectedIssueType = null;
            descriptionController.clear();
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black87),
        centerTitle: true,
        title: Text(
          'Report an Issue',
          style: textTheme.titleMedium?.copyWith(
            color: const Color(0xFF215496),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9FB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Booking ID
                Text("Booking ID",
                    style: textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _openBookingSelector(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: TextEditingController(
                        text: selectedBooking ?? '',
                      ),
                      decoration: _inputDecoration("Select Booking"),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Issue Type Dropdown
                Text("Select Type",
                    style: textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedIssueType,
                  hint: const Text("Issue Type"),
                  decoration: _inputDecoration(""),
                  items: issueTypes
                      .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedIssueType = val),
                ),
                const SizedBox(height: 16),

                // Description
                Text("Description",
                    style: textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: _inputDecoration("Write here...."),
                ),
                const SizedBox(height: 16),

                // Upload Box
                GestureDetector(
                  onTap: pickImages,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1FB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFD2DDEE),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.upload_outlined,
                            size: 28, color: Color(0xFF215496)),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.black87),
                            children: [
                              TextSpan(
                                text: "Click to upload",
                                style: const TextStyle(
                                  color: Color(0xFF215496),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: " or Drop a file here"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "PNG, JPG, JPEG (max. 1mb )",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Selected Files Preview
                if (selectedFiles.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      selectedFiles.length,
                          (index) => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.file(
                              selectedFiles[index],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () => removeImage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.close,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF215496),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text(
                      _isSubmitting ? "Submitting..." : "Submit",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  void _openBookingSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: widget.bookings.map((booking) {
            return ListTile(
              title: Text(booking.bookingId),
              onTap: () {
                setState(() => selectedBooking = booking.bookingId);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
