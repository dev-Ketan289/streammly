import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice2/places.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationController extends GetxController {
  // Observables
  final rxLat = 19.0760.obs; // Default to Mumbai coordinates
  final rxLng = 72.8777.obs;
  final RxList<Prediction> suggestions = <Prediction>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLocationServiceEnabled = true.obs;
  final RxString selectedAddress = ''.obs;
  final RxList<SavedAddress> savedAddresses = <SavedAddress>[].obs;

  // Google Maps services
  late GoogleMapsPlaces _places;

  // Map controller reference
  GoogleMapController? _mapController;

  // Constants
  static const String _apiKey = 'AIzaSyDC392D0em2z_kvN5qjga51hhtIrFqzp8Q';
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

  // Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load last known location
      final lastLocation = prefs.getString(_lastLocationKey);
      if (lastLocation != null) {
        final locationData = json.decode(lastLocation);
        rxLat.value = locationData['lat'] ?? 19.0760;
        rxLng.value = locationData['lng'] ?? 72.8777;
        selectedAddress.value = locationData['address'] ?? '';
      }

      // Load saved addresses
      final savedAddressesJson = prefs.getStringList(_savedAddressesKey);
      if (savedAddressesJson != null) {
        savedAddresses.assignAll(savedAddressesJson.map((json) => SavedAddress.fromJson(json)).toList());
      } else {
        // Add default addresses if none exist
        _addDefaultAddresses();
      }
    } catch (e) {
      print('Failed to load saved data: $e');
      _addDefaultAddresses();
    }
  }

  // Add default addresses for first-time users
  void _addDefaultAddresses() {
    savedAddresses.assignAll([
      SavedAddress(id: '1', title: 'Home', address: '203/A, Avisha Building, Girgaon, Mumbai', lat: 18.9547, lng: 72.8156, type: AddressType.home),
      SavedAddress(id: '2', title: 'Work', address: '104, Dinkar Co-Op Society, Mahim, Mumbai', lat: 19.0330, lng: 72.8397, type: AddressType.work),
    ]);
    _saveSavedAddresses();
  }

  // Check if location services are enabled
  Future<void> _checkLocationServices() async {
    isLocationServiceEnabled.value = await Geolocator.isLocationServiceEnabled();
  }

  // Public method to get current location with improved error handling
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;

      // Check if location services are enabled
      if (!await Geolocator.isLocationServiceEnabled()) {
        isLocationServiceEnabled.value = false;
        _showLocationServiceDialog();
        return;
      }

      // Check and request permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Permission Denied', 'Location permissions are denied. Please enable them in settings.', snackPosition: SnackPosition.BOTTOM);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied Forever',
          'Location permissions are permanently denied. Please enable them in app settings.',
          snackPosition: SnackPosition.BOTTOM,
          mainButton: TextButton(onPressed: () => Geolocator.openAppSettings(), child: const Text('Open Settings')),
        );
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 10)));

      // Update location
      await updateLocation(position.latitude, position.longitude);

      // Get address for the current location
      await _getAddressFromCoordinates(position.latitude, position.longitude);

      Get.snackbar('Success', 'Current location detected successfully', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print('Location error: $e');
      Get.snackbar('Location Error', 'Failed to get current location: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Show dialog when location services are disabled
  void _showLocationServiceDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text('Location services are disabled. Please enable them to use this feature.'),
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

  // Update location with coordinates
  Future<void> updateLocation(double lat, double lng) async {
    rxLat.value = lat;
    rxLng.value = lng;

    // Animate camera if map controller is available
    _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));

    // Save last location
    await _saveLastLocation(lat, lng);
  }

  // Get address from coordinates using reverse geocoding
  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      final response = await _places.searchNearbyWithRadius(
        Location(lat: lat, lng: lng),
        50, // 50 meter radius
      );

      if (response.isOkay && response.results.isNotEmpty) {
        selectedAddress.value = response.results.first.name ?? 'Selected Location';
      }
    } catch (e) {
      print('Failed to get address: $e');
      selectedAddress.value = 'Selected Location';
    }
  }

  // Save last location to SharedPreferences
  Future<void> _saveLastLocation(double lat, double lng) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationData = {'lat': lat, 'lng': lng, 'address': selectedAddress.value, 'timestamp': DateTime.now().millisecondsSinceEpoch};
      await prefs.setString(_lastLocationKey, json.encode(locationData));
    } catch (e) {
      print('Failed to save last location: $e');
    }
  }

  // Search suggestion method with debouncing
  void searchAutocomplete(String input) async {
    if (input.isEmpty) {
      suggestions.clear();
      return;
    }

    // Simple debouncing - cancel previous search if typing fast
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final response = await _places.autocomplete(
        input,
        components: [Component(Component.country, "in")],
        // Restrict to India
        types: [],
        // Allow all types
        strictbounds: false,
        location: Location(lat: rxLat.value, lng: rxLng.value),
        radius: 50000, // 50km radius for better suggestions
      );

      if (response.isOkay) {
        suggestions.assignAll(response.predictions);
      } else {
        suggestions.clear();
        print('Autocomplete error: ${response.errorMessage}');
      }
    } catch (e) {
      suggestions.clear();
      print('Autocomplete fetch failed: $e');
    }
  }

  // Clear suggestions
  void clearSuggestions() {
    suggestions.clear();
  }

  // Set map controller from map screen
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  // On prediction tap, get coordinates & animate camera
  Future<void> selectPrediction(Prediction prediction) async {
    try {
      final details = await _places.getDetailsByPlaceId(prediction.placeId!);
      if (details.isOkay) {
        final location = details.result.geometry!.location;
        await updateLocation(location.lat, location.lng);
        selectedAddress.value = prediction.description ?? 'Selected Location';

        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(location.lat, location.lng), 15));

        suggestions.clear();
      } else {
        print("Place detail error: ${details.errorMessage}");
        Get.snackbar('Error', 'Failed to get place details');
      }
    } catch (e) {
      print('Failed to get place details: $e');
      Get.snackbar('Error', 'Failed to select location');
    }
  }

  // Save the selected location (can be used for order/delivery purposes)
  Future<void> saveSelectedLocation() async {
    await _saveLastLocation(rxLat.value, rxLng.value);
    Get.snackbar('Location Saved', 'Your selected location has been saved', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
  }

  // Select saved address
  Future<void> selectSavedAddress(SavedAddress address) async {
    await updateLocation(address.lat, address.lng);
    selectedAddress.value = address.address;

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(address.lat, address.lng), 15));
  }

  // Add new saved address
  Future<void> addSavedAddress(SavedAddress address) async {
    savedAddresses.add(address);
    await _saveSavedAddresses();
    Get.snackbar('Address Added', '${address.title} has been added to saved addresses', snackPosition: SnackPosition.BOTTOM);
  }

  // Remove saved address
  Future<void> removeSavedAddress(String id) async {
    savedAddresses.removeWhere((address) => address.id == id);
    await _saveSavedAddresses();
    Get.snackbar('Address Removed', 'Address has been removed from saved addresses', snackPosition: SnackPosition.BOTTOM);
  }

  // Save addresses to SharedPreferences
  Future<void> _saveSavedAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final addressesJson = savedAddresses.map((address) => address.toJson()).toList();
      await prefs.setStringList(_savedAddressesKey, addressesJson);
    } catch (e) {
      print('Failed to save addresses: $e');
    }
  }

  // Get distance between two points
  double getDistanceBetween(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }

  // Get formatted address string
  String get formattedCurrentLocation {
    return selectedAddress.value.isNotEmpty ? selectedAddress.value : 'Lat: ${rxLat.value.toStringAsFixed(6)}, Lng: ${rxLng.value.toStringAsFixed(6)}';
  }
}

// Model for saved addresses
class SavedAddress {
  final String id;
  final String title;
  final String address;
  final double lat;
  final double lng;
  final AddressType type;
  final DateTime? createdAt;

  SavedAddress({required this.id, required this.title, required this.address, required this.lat, required this.lng, required this.type, this.createdAt});

  factory SavedAddress.fromJson(String jsonString) {
    final json = jsonDecode(jsonString);
    return SavedAddress(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
      type: AddressType.values.firstWhere((e) => e.toString() == json['type'], orElse: () => AddressType.other),
      createdAt: json['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(json['createdAt']) : null,
    );
  }

  String toJson() {
    return jsonEncode({'id': id, 'title': title, 'address': address, 'lat': lat, 'lng': lng, 'type': type.toString(), 'createdAt': createdAt?.millisecondsSinceEpoch});
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
