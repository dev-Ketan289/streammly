import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/repository/header_repo.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/theme.dart' as theme;
import 'package:streammly/views/screens/home/home_screen.dart';
import 'package:streammly/views/screens/package/booking/booking_page.dart';

import 'controllers/home_screen_controller.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final controller = Get.put(NavigationController());
  final homeController = Get.put(HomeController(homeRepo: HomeRepo(apiClient: ApiClient(appBaseUrl: "192.168.1.113/", sharedPreferences: Get.find()))));

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Obx(() => controller.screens[controller.selectedIndex.value]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Obx(
          () => CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 3,
              onPressed: () {
                controller.selectedIndex.value = 2;
              },
              child: Icon(Iconsax.bag, size: 26, color: controller.selectedIndex.value == 2 ? theme.primaryColor : Colors.grey),
            ),
          ),
        ),
        bottomNavigationBar: Obx(() {
          return ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            child: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 5,
              color: const Color(0xffF1F6FB),
              child: SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(icon: Assets.svgHome, label: 'Home', index: 0),
                    _buildNavItem(icon: Assets.svgShop, label: 'Shop', index: 1),
                    const SizedBox(width: 25), // Space for FAB
                    _buildNavItem(icon: Assets.svgBooking, label: 'Bookings', index: 3),
                    _buildNavItem(icon: Assets.svgMore, label: 'More', index: 4),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavItem({required String icon, required String label, required int index}) {
    final isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.selectedIndex.value = index,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SvgPicture.asset(icon), const SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.indigo : Colors.black54))],
      ),
    );
  }
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Widget> screens = [
    HomeScreen(),
    const Center(child: Text("Shop Page Coming Soon")),
    const Center(child: Text("My Cart Page Coming Soon")),
    BookingPage(),
    const Center(child: Text("More Page Coming Soon")),
  ];
}

// ADD THIS STATIC METHOD TO CREATE STANDALONE BOTTOM NAV
class NavigationHelper {
  static Widget buildBottomNav() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: const Color(0xffF1F6FB),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Iconsax.home, label: 'Home', index: 0),
              _buildNavItem(icon: Iconsax.shop, label: 'Shop', index: 1),
              const SizedBox(width: 25), // Space for FAB
              _buildNavItem(icon: Iconsax.calendar, label: 'Bookings', index: 3),
              _buildNavItem(icon: Iconsax.more, label: 'More', index: 4),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    return GestureDetector(
      onTap: () {
        try {
          Get.find<NavigationController>().selectedIndex.value = index;
          Get.back();
        } catch (e) {
          Get.offAll(() => const NavigationMenu());
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(icon, color: Colors.black54), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54))],
      ),
    );
  }

  static Widget buildFloatingButton() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.white,
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        elevation: 3,
        onPressed: () {
          try {
            Get.find<NavigationController>().selectedIndex.value = 2;
            Get.back();
          } catch (e) {
            Get.offAll(() => const NavigationMenu());
          }
        },
        child: const Icon(Iconsax.bag, size: 26, color: Colors.grey),
      ),
    );
  }
}
