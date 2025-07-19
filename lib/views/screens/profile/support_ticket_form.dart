import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../controllers/auth_controller.dart';

class SupportTicketFormPage extends StatefulWidget {
  const SupportTicketFormPage({super.key});

  @override
  State<SupportTicketFormPage> createState() => _SupportTicketFormPageState();
}

class _SupportTicketFormPageState extends State<SupportTicketFormPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<File> selectedFiles = [];
  String? selectedBooking;

  final AuthController authController = Get.find<AuthController>();
  bool _isSubmitting = false; // <-- Flag to prevent multiple taps

  Future<void> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      final files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        selectedFiles.addAll(files);
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  Future<void> submitSupportTicket() async {
    if (_isSubmitting) return; // prevent multiple clicks
    setState(() {
      _isSubmitting = true;
    });

    final String token = authController.getUserToken();

    if (token.isEmpty) {
      Get.snackbar("Error", "You must be logged in to submit a ticket.");
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    final uri = Uri.parse(
      'https://admin.streammly.com/api/v1/support-ticket/addsupportticket',
    );
    // final uri = Uri.parse('http://192.168.1.113:8000/api/v1/support-ticket/addsupportticket');

    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['booking_id'] = '1'
          ..fields['title'] = titleController.text
          ..fields['description'] = descriptionController.text;

    if (selectedFiles.isNotEmpty) {
      final file = selectedFiles.first;
      final fileName = file.path.split('/').last;

      request.files.add(
        await http.MultipartFile.fromPath(
          'reference_image',
          file.path,
          filename: fileName,
        ),
      );
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200) {
        final resBody = json.decode(response.body);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Support ticket submitted successfully!'),
            ),
          );
          titleController.clear();
          descriptionController.clear();
          setState(() {
            selectedFiles.clear();
          });
        }
      } else {
        debugPrint('Error: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('Exception: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black87),
        centerTitle: true,
        title: Text(
          'Support Ticket',
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: screenHeight * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Booking",
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedBooking,
                  items:
                      ['Booking #1234', 'Booking #5678']
                          .map(
                            (booking) => DropdownMenuItem(
                              value: booking,
                              child: Text(booking, style: textTheme.bodyMedium),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => selectedBooking = value),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Select Booking',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Title",
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  style: textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Description",
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 6,
                  style: textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Write here....',
                    hintStyle: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: pickImages,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 40,
                          color: theme.iconTheme.color?.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Click to upload",
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: " or Drop files here"),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "PNG, JPG, JPEG (max. 1mb )",
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (selectedFiles.isNotEmpty) ...[
                  Text(
                    "Selected Files",
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(
                      selectedFiles.length,
                      (index) => Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              selectedFiles[index],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () => removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        _isSubmitting
                            ? null
                            : () {
                              if (titleController.text.isEmpty ||
                                  descriptionController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please fill all required fields',
                                    ),
                                  ),
                                );
                                return;
                              }
                              submitSupportTicket();
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isSubmitting ? "Submitting..." : "Submit",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
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
}
