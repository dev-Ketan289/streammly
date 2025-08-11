import 'package:flutter/material.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'custom_textfield.dart';

enum AddressPageMode { add, edit }

class AddressModel {
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
  final bool isPrimary;

  AddressModel({
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

  const AddressPage({
    super.key,
    required this.mode,
    this.existingAddress,
  });

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  // Controllers
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _pincodeController = TextEditingController();

  String? _selectedState;
  String? _selectedCity;
  bool _setAsPrimary = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == AddressPageMode.edit && widget.existingAddress != null) {
      _line1Controller.text = widget.existingAddress!.line1;
      _line2Controller.text = widget.existingAddress!.line2;
      _pincodeController.text = widget.existingAddress!.pincode;
      _selectedState = widget.existingAddress!.state;
      _selectedCity = widget.existingAddress!.city;
      _setAsPrimary = widget.existingAddress!.isPrimary;
    }
  }

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    _pincodeController.dispose();
    super.dispose();
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
              if (_line1Controller.text.trim().isEmpty ||
                  _pincodeController.text.trim().isEmpty ||
                  _selectedState == null ||
                  _selectedCity == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }

              final updatedAddress = AddressModel(
                line1: _line1Controller.text.trim(),
                line2: _line2Controller.text.trim(),
                city: _selectedCity ?? '',
                state: _selectedState ?? '',
                pincode: _pincodeController.text.trim(),
                isPrimary: _setAsPrimary,
              );

              Navigator.pop(context, updatedAddress);
            },
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                children: [
                  CustomTextField(
                    labelText: 'Address Line 1',
                    hintText: 'Address Line 1',
                    controller: _line1Controller,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    labelText: 'Address Line 2',
                    hintText: 'Address Line 2',
                    controller: _line2Controller,
                  ),
                  const SizedBox(height: 12),
                  _buildCSCField(),
                  const SizedBox(height: 12),
                  CustomTextField(
                    labelText: 'Pincode',
                    hintText: '400001',
                    controller: _pincodeController,
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
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
            )
          ],
        ),
      ),
    );
  }
}
