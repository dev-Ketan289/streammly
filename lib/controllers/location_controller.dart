import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice2/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/screens/common/widgets/add_new_address.dart';
import 'booking_form_controller.dart';
import 'category_controller.dart';
import 'company_controller.dart';
import 'home_screen_controller.dart';

class LocationController extends GetxController {
  double lat = 19.0760;
  double lng = 72.8777;
  List<Prediction> suggestions = [];
  bool isLoading = false;
  bool isLocationServiceEnabled = true;
  String selectedAddress = '';
  List<SavedAddress> savedAddresses = [];
  Map<String, String> _detailedAddress = {};

  late GoogleMapsPlaces _places;
  GoogleMapController? _mapController;

  static const String _apiKey = 'YOUR_API_KEY';
  static const String _savedAddressesKey = 'saved_addresses';
  static const String _lastLocationKey = 'last_location';

  @override
  void onInit() {
    super.onInit();
    _places = GoogleMapsPlaces(apiKey: _apiKey);
    _loadSavedData();
    _checkLocationServices();
  }

  @override
  void onClose() {
    _mapController?.dispose();
    super.onClose();
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastLocation = prefs.getString(_lastLocationKey);
      if (lastLocation != null) {
        final locationData = json.decode(lastLocation);
        lat = locationData['lat'] ?? 19.0760;
        lng = locationData['lng'] ?? 72.8777;
        selectedAddress = locationData['address'] ?? '';
      }

      final savedAddressesJson = prefs.getStringList(_savedAddressesKey);
      if (savedAddressesJson != null) {
        savedAddresses = savedAddressesJson
            .map((json) => SavedAddress.fromJson(json))
            .toList();
      } else {
        _addDefaultAddresses();
      }
    } catch (e) {
      _addDefaultAddresses();
    }
    update();
  }

  void _addDefaultAddresses() {
    savedAddresses = [
      SavedAddress(
        id: '1',
        title: 'Home',
        address: '203/A, Avisha Building, Girgaon, Mumbai',
        line1: '203/A, Avisha Building',
        line2: '',
        city: 'Girgaon',
        state: 'Maharashtra',
        pincode: '400004',
        lat: 18.9547,
        lng: 72.8156,
        type: AddressType.home,
      ),
      SavedAddress(
        id: '2',
        title: 'Work',
        address: '104, Dinkar Co-Op Society, Mahim, Mumbai',
        line1: '104, Dinkar Co-Op Society',
        line2: '',
        city: 'Mahim',
        state: 'Maharashtra',
        pincode: '400016',
        lat: 19.0330,
        lng: 72.8397,
        type: AddressType.work,
      ),
    ];
    _saveSavedAddresses();
    update();
  }

  Future<void> _checkLocationServices() async {
    isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    update();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading = true;
      update();

      if (!await Geolocator.isLocationServiceEnabled()) {
        isLocationServiceEnabled = false;
        _showLocationServiceDialog();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Denied',
            'Location permissions are denied.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied Forever',
          'Location permissions are permanently denied.',
          snackPosition: SnackPosition.BOTTOM,
          mainButton: TextButton(
            onPressed: () => Geolocator.openAppSettings(),
            child: const Text('Open Settings'),
          ),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      await updateLocation(position.latitude, position.longitude);
    } finally {
      isLoading = false;
      update();
    }
  }

  void _showLocationServiceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text('Please enable location services.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> updateLocation(double lat, double lng,
      {bool moveCamera = true}) async {
    this.lat = lat;
    this.lng = lng;

    if (moveCamera && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
      );
    }

    await getAddressFromCoordinates(lat, lng);
    await _saveLastLocation(lat, lng);
    update();

    final homeCtrl = Get.find<HomeController>();
    homeCtrl.fetchSlides();
    homeCtrl.fetchRecommendedCompanies();
    Get.find<CategoryController>().fetchCategories();
    Get.find<CompanyController>().fetchCompanyById(1);
    Get.find<BookingController>().fetchBookings();
  }

  Future<void> getAddressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        selectedAddress =
        '${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}';
        
        // Store detailed address components for use in address forms
        _detailedAddress = {
          'line1': '${place.name ?? ''} ${place.street ?? ''}'.trim(),
          'city': place.locality ?? '',
          'state': place.administrativeArea ?? '',
          'pincode': place.postalCode ?? '',
          'country': place.country ?? '',
        };
      } else {
        selectedAddress = 'Selected Location';
        _detailedAddress = {};
      }
    } catch (e) {
      selectedAddress = 'Selected Location';
      _detailedAddress = {};
    }
    update();
  }

  Future<void> _saveLastLocation(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    final locationData = {
      'lat': lat,
      'lng': lng,
      'address': selectedAddress,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(_lastLocationKey, json.encode(locationData));
  }

  void searchAutocomplete(String input) async {
    if (input.isEmpty) {
      suggestions.clear();
      update();
      return;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final response = await _places.autocomplete(
        input,
        components: [Component(Component.country, "in")],
        location: Location(lat: lat, lng: lng),
        radius: 50000,
      );

      if (response.isOkay) {
        suggestions = response.predictions;
      } else {
        suggestions.clear();
      }
    } catch (e) {
      suggestions.clear();
    }
    update();
  }

  void clearSuggestions() {
    suggestions.clear();
    update();
  }

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> selectPrediction(Prediction prediction) async {
    try {
      final details = await _places.getDetailsByPlaceId(prediction.placeId!);
      if (details.isOkay) {
        final location = details.result.geometry!.location;
        await updateLocation(location.lat, location.lng);
        selectedAddress = prediction.description ?? 'Selected Location';
      } else {
        Get.snackbar('Error', 'Failed to get place details');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to select location');
    }
    update();
  }

  Future<void> saveSelectedLocation() async {
    await _saveLastLocation(lat, lng);
    Get.snackbar(
      'Location Saved',
      'Your selected location has been saved',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> selectSavedAddress(SavedAddress address) async {
    await updateLocation(address.lat, address.lng);
    selectedAddress = address.address;
    update();
  }

  Future<void> addSavedAddress(SavedAddress address) async {
    savedAddresses.add(address);
    await _saveSavedAddresses();
    update();
  }

  Future<void> updateSavedAddress(String id, AddressModel updated) async {
    final index = savedAddresses.indexWhere((a) => a.id == id);
    if (index != -1) {
      savedAddresses[index] = SavedAddress(
        id: id,
        title: savedAddresses[index].title,
        address:
        '${updated.line1}, ${updated.line2}, ${updated.city}, ${updated.state}, ${updated.pincode}',
        line1: updated.line1,
        line2: updated.line2,
        city: updated.city,
        state: updated.state,
        pincode: updated.pincode,
        lat: savedAddresses[index].lat,
        lng: savedAddresses[index].lng,
        type: savedAddresses[index].type,
        createdAt: savedAddresses[index].createdAt,
      );
      await _saveSavedAddresses();
      update();
    }
  }

  Future<void> removeSavedAddress(String id) async {
    savedAddresses.removeWhere((address) => address.id == id);
    await _saveSavedAddresses();
    update();
  }

  Future<void> _saveSavedAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final addressesJson =
    savedAddresses.map((address) => address.toJson()).toList();
    await prefs.setStringList(_savedAddressesKey, addressesJson);
  }

  double getDistanceBetween(
      double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }

  String get formattedCurrentLocation {
    return selectedAddress.isNotEmpty
        ? selectedAddress
        : 'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';
  }

  Map<String, String> get detailedAddress => _detailedAddress;

  void clearSelectedAddress() {
    selectedAddress = '';
    _detailedAddress = {};
    update();
  }

  Future<bool> hasSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_lastLocationKey);
  }
}

class SavedAddress {
  final String id;
  final String title;
  final String address;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pincode;
  final double lat;
  final double lng;
  final AddressType type;
  final DateTime? createdAt;

  SavedAddress({
    required this.id,
    required this.title,
    required this.address,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.lat,
    required this.lng,
    required this.type,
    this.createdAt,
  });

  factory SavedAddress.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return SavedAddress(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      line1: json['line1'],
      line2: json['line2'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      type: AddressType.values.firstWhere(
            (e) => e.toString() == json['type'],
        orElse: () => AddressType.other,
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : null,
    );
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'title': title,
      'address': address,
      'line1': line1,
      'line2': line2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'lat': lat,
      'lng': lng,
      'type': type.toString(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
    });
  }
}

enum AddressType { home, work, other }

extension AddressTypeExtension on AddressType {
  IconData get icon {
    switch (this) {
      case AddressType.home:
        return Icons.home;
      case AddressType.work:
        return Icons.work;
      case AddressType.other:
        return Icons.location_on;
    }
  }

  Color get color {
    switch (this) {
      case AddressType.home:
        return Colors.green;
      case AddressType.work:
        return Colors.blue;
      case AddressType.other:
        return Colors.orange;
    }
  }
}
