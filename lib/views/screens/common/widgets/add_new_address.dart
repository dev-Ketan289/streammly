import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'custom_textfield.dart';

enum AddressPageMode { add, edit }

class AddressModel {
  final String title;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
  final bool isPrimary;

  AddressModel({
    required this.title,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.isPrimary,
  });
}

class AddressPage extends StatefulWidget {
  final AddressPageMode mode;
  final AddressModel? existingAddress;

  const AddressPage({super.key, required this.mode, this.existingAddress});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final controller = Get.put(LocationController());

  // Controllers
  final titleController = TextEditingController();
  final line1Controller = TextEditingController();
  final line2Controller = TextEditingController();
  final pincodeController = TextEditingController();

  String? _selectedState;
  String? _selectedCity;
  bool _setAsPrimary = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == AddressPageMode.edit && widget.existingAddress != null) {
      titleController.text = widget.existingAddress!.title;
      line1Controller.text = widget.existingAddress!.line1;
      line2Controller.text = widget.existingAddress!.line2;
      pincodeController.text = widget.existingAddress!.pincode;
      _selectedState = widget.existingAddress!.state;
      _selectedCity = widget.existingAddress!.city;
      _setAsPrimary = widget.existingAddress!.isPrimary;
    }

    // Listen to location changes to update address fields
    controller.addListener(_onLocationChanged);
  }

  @override
  void dispose() {
    titleController.dispose();
    line1Controller.dispose();
    line2Controller.dispose();
    pincodeController.dispose();
    controller.removeListener(_onLocationChanged);
    super.dispose();
  }

  void _onLocationChanged() {
    // Update address fields with the selected address from map
    if (controller.selectedAddress.isNotEmpty &&
        controller.selectedAddress != 'Selected Location') {
      final detailedAddress = controller.detailedAddress;

      // Update address line 1
      if (detailedAddress['line1']?.isNotEmpty == true) {
        line1Controller.text = detailedAddress['line1']!;
      } else {
        line1Controller.text = controller.selectedAddress;
      }

      // Update city if available
      if (detailedAddress['city']?.isNotEmpty == true) {
        setState(() {
          _selectedCity = detailedAddress['city'];
        });
      }

      // Update state if available
      if (detailedAddress['state']?.isNotEmpty == true) {
        setState(() {
          _selectedState = detailedAddress['state'];
        });
      }

      // Update pincode if available
      if (detailedAddress['pincode']?.isNotEmpty == true) {
        pincodeController.text = detailedAddress['pincode']!;
      }
    }
  }

  Widget _buildCSCField() {
    // ✅ Always allow selection for both Add and Edit
    return CSCPickerPlus(
      layout: Layout.vertical,
      flagState: CountryFlag.DISABLE,
      defaultCountry: CscCountry.India,
      disableCountry: true,
      showStates: true,
      showCities: true,
      currentState: _selectedState,
      currentCity: _selectedCity,
      dropdownDecoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      disabledDropdownDecoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      selectedItemStyle: const TextStyle(color: Colors.black, fontSize: 16),
      dropdownHeadingStyle: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      dropdownItemStyle: const TextStyle(fontSize: 14),
      onStateChanged: (value) {
        setState(() {
          _selectedState = value ?? '';
          _selectedCity = null;
        });
      },
      onCityChanged: (value) {
        setState(() {
          _selectedCity = value ?? '';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.mode == AddressPageMode.edit;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEdit ? 'Edit Address' : 'Add New Address'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: () {
              if (titleController.text.trim().isEmpty ||
                  line1Controller.text.trim().isEmpty ||
                  pincodeController.text.trim().isEmpty ||
                  _selectedState == null ||
                  _selectedCity == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all required fields'),
                  ),
                );
                return;
              }

              final updatedAddress = AddressModel(
                title: titleController.text.trim(),
                line1: line1Controller.text.trim(),
                line2: line2Controller.text.trim(),
                city: _selectedCity ?? '',
                state: _selectedState ?? '',
                pincode: pincodeController.text.trim(),
                isPrimary: _setAsPrimary,
              );

              Navigator.pop(context, updatedAddress);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Address Details',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    // Title field
                    CustomTextField(
                      labelText: 'Address Title',
                      hintText: 'e.g., Home, Work, Office',
                      controller: titleController,
                    ),
                    const SizedBox(height: 12),
                    // Address Line 1 field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          labelText: 'Address Line 1',
                          hintText: 'Address Line 1',
                          controller: line1Controller,
                        ),
                        // if (controller.selectedAddress.isNotEmpty &&
                        //     controller.selectedAddress != 'Selected Location')
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 4, left: 4),
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.check_circle,
                        //           color: Colors.green,
                        //           size: 14,
                        //         ),
                        //         const SizedBox(width: 4),
                        //         Text(
                        //           'Address from map',
                        //           style: TextStyle(
                        //             color: Colors.green,
                        //             fontSize: 11,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      labelText: 'Address Line 2',
                      hintText: 'Address Line 2',
                      controller: line2Controller,
                    ),
                    const SizedBox(height: 12),
                    _buildCSCField(),
                    const SizedBox(height: 12),
                    CustomTextField(
                      labelText: 'Pincode',
                      hintText: '400001',
                      controller: pincodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: _setAsPrimary,
                          onChanged: (val) {
                            setState(() {
                              _setAsPrimary = val ?? false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          'Set as Primary Address',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Map section with instruction
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 200,

                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(controller.lat, controller.lng),
                        zoom: 15,
                      ),
                      onMapCreated: (mapController) {
                        controller.setMapController(mapController);
                      },
                      onTap: (LatLng position) async {
                        controller.updateLocation(
                          position.latitude,
                          position.longitude,
                        );
                        // Wait for geocoding to complete
                        await Future.delayed(const Duration(milliseconds: 500));
                      },
                      markers: {
                        Marker(
                          markerId: const MarkerId("selected_location"),
                          position: LatLng(controller.lat, controller.lng),
                        ),
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
