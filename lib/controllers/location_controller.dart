import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice2/places.dart';

class LocationController extends GetxController {
  // Observables
  final rxLat = 0.0.obs;
  final rxLng = 0.0.obs;
  final RxList<Prediction> suggestions = <Prediction>[].obs;

  // Google Maps services
  late GoogleMapsPlaces _places;

  // Map controller reference
  late GoogleMapController _mapController;

  @override
  void onInit() {
    super.onInit();
    _places = GoogleMapsPlaces(apiKey: 'AIzaSyDC392D0em2z_kvN5qjga51hhtIrFqzp8Q');
    getCurrentLocation(); // Automatically fetch current location
  }

  // Public method to get current location
  Future<void> getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        Get.snackbar('Error', 'Enable location services');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permission permanently denied');
        return;
      }

      var position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.bestForNavigation));

      rxLat.value = position.latitude;
      rxLng.value = position.longitude;
    } catch (e) {
      Get.snackbar('Location Error', e.toString());
    }
  }

  // Search suggestion method
  void searchAutocomplete(String input) async {
    if (input.isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      final response = await _places.autocomplete(
        input,
        components: [Component(Component.country, "in")], // Restrict to India
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
        rxLat.value = location.lat;
        rxLng.value = location.lng;

        _mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(location.lat, location.lng), 15));

        suggestions.clear();
      } else {
        print("Place detail error: ${details.errorMessage}");
      }
    } catch (e) {
      print('Failed to get place details: $e');
    }
  }
}
