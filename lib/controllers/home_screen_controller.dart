import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable loading state
  var isLoading = true.obs;

  // Observable lists for categories and recommendations
  var categories = <String>[].obs;
  var recommendedItems = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  void fetchHomeData() async {
    // Simulate a delay (API call)
    await Future.delayed(const Duration(seconds: 2));

    // Dummy data
    categories.value = ['Venue', 'Photographer', 'Event Organiser', 'Makeup Artist', 'Food & Caterers'];

    recommendedItems.value = ['FocusPoint Studio', 'Velvet Parlour', 'Flavor Theory', 'Echo Booth'];

    isLoading.value = false;
  }
}
