import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'package:streammly/models/profile/user_profile_model.dart';
import 'custom_textfield.dart';

class AddressPage extends StatefulWidget {
  final Address? address;

  const AddressPage({super.key, this.address});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final LocationController controller = Get.find<LocationController>();
  final AuthController authController = Get.find<AuthController>();

  // Controllers
  final titleController = TextEditingController();
  final line1Controller = TextEditingController();
  final line2Controller = TextEditingController();
  final landmarkController = TextEditingController();
  final pincodeController = TextEditingController();

  String? _selectedState;
  String? _selectedCity;
  bool _setAsPrimary = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      // Prefill fields for edit mode
      titleController.text = widget.address!.title ?? '';
      line1Controller.text = widget.address!.addressOne ?? '';
      line2Controller.text = widget.address!.addressTwo ?? '';
      landmarkController.text = widget.address!.landmark ?? '';
      pincodeController.text = widget.address!.pincode ?? '';
      _selectedState = widget.address!.state ?? '';
      _selectedCity = widget.address!.city ?? '';
      _setAsPrimary = widget.address!.isDefault == 1;
      controller.updateLocation(
        double.tryParse(widget.address!.latitude ?? '0') ?? 0,
        double.tryParse(widget.address!.longitude ?? '0') ?? 0,
      );
    }
    controller.addListener(_onLocationChanged);
  }

  @override
  void dispose() {
    titleController.dispose();
    line1Controller.dispose();
    line2Controller.dispose();
    landmarkController.dispose();
    pincodeController.dispose();
    controller.removeListener(_onLocationChanged);
    super.dispose();
  }

  void _onLocationChanged() {
    if (controller.selectedAddress.isNotEmpty &&
        controller.selectedAddress != 'Selected Location') {
      final detailedAddress = controller.detailedAddress;
      if (detailedAddress['line1']?.isNotEmpty == true) {
        line1Controller.text = detailedAddress['line1']!;
      } else {
        line1Controller.text = controller.selectedAddress;
      }
      if (detailedAddress['city']?.isNotEmpty == true) {
        setState(() {
          _selectedCity = detailedAddress['city'];
        });
      }
      if (detailedAddress['state']?.isNotEmpty == true) {
        setState(() {
          _selectedState = detailedAddress['state'];
        });
      }
      if (detailedAddress['pincode']?.isNotEmpty == true) {
        pincodeController.text = detailedAddress['pincode']!;
      }
    }
  }

  Widget _buildCSCField() {
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
    final isEditMode = widget.address != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(isEditMode ? 'Edit Address' : 'Add New Address'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: () async {
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

              final response =
                  isEditMode
                      ? await authController.updateUserAddress(
                        widget.address!.id.toString(),
                        titleController.text.trim(),
                        line1Controller.text.trim(),
                        line2Controller.text.trim(),
                        landmarkController.text.trim(),
                        _selectedCity!,
                        _selectedState!,
                        pincodeController.text.trim(),
                        controller.lat.toString(),
                        controller.lng.toString(),
                        _setAsPrimary ? "1" : "0",
                      )
                      : await authController.addUserAddress(
                        titleController.text.trim(),
                        line1Controller.text.trim(),
                        line2Controller.text.trim(),
                        landmarkController.text.trim(),
                        _selectedCity!,
                        _selectedState!,
                        pincodeController.text.trim(),
                        controller.lat.toString(),
                        controller.lng.toString(),
                        _setAsPrimary ? "1" : "0",
                      );

              if (response.isSuccess) {
                Navigator.pop(context, true);
                Get.snackbar(
                  'Success',
                  isEditMode
                      ? 'Address updated successfully'
                      : 'Address added successfully',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Error',
                  response.message,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
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
              Text(
                isEditMode ? 'Edit Address Details' : 'Address Details',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
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
                    CustomTextField(
                      labelText: 'Address Title',
                      hintText: 'e.g., Home, Work, Office',
                      controller: titleController,
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          labelText: 'Address Line 1',
                          hintText: 'Address Line 1',
                          controller: line1Controller,
                        ),
                        if (controller.selectedAddress.isNotEmpty &&
                            controller.selectedAddress != 'Selected Location')
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Address from map',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      labelText: 'Address Line 2',
                      hintText: 'Address Line 2',
                      controller: line2Controller,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      labelText: 'Landmark',
                      hintText: 'e.g., Near Park, Opposite Mall',
                      controller: landmarkController,
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
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
