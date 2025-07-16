import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/theme.dart' as theme;
import 'package:streammly/views/screens/home/home_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GetBuilder<NavigationController>(builder: (_) => controller.screens[controller.selectedIndex]()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GetBuilder<NavigationController>(
          builder:
              (_) => CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: FloatingActionButton(
                  shape: const CircleBorder(
                    
                  ),
                  backgroundColor: Colors.white,
                  elevation: 3,
                  onPressed: () {
                    controller.setIndex(2);
                  },
                  child: Container(height: 40, width: 40, decoration: BoxDecoration(color: const Color(0xffD9D9D9),shape: BoxShape.circle ), child: SvgPicture.asset(Assets.svgCarttt, fit: BoxFit.scaleDown,),),
                ),
              ),
        ),
        bottomNavigationBar: GetBuilder<NavigationController>(
          builder: (_) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
          },
        ),
      ),
    );
  }

  Widget _buildNavItem({required String icon, required String label, required int index}) {
    final isSelected = controller.selectedIndex == index;

    return GestureDetector(
      onTap: () => controller.setIndex(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SvgPicture.asset(icon), const SizedBox(height: 4), Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.indigo : Colors.black54))],
      ),
    );
  }
}

class NavigationController extends GetxController {
  int selectedIndex = 0;

  final List<Widget Function()> screens = [() => const HomeScreen(), () => const Placeholder(), () => const Placeholder(), () => const Placeholder(), () => const Placeholder()];

  void setIndex(int index) {
    selectedIndex = index;
    update();
  }
}

// Static methods for use outside NavigationMenu
class NavigationHelper {
  static Widget buildBottomNav() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        color: const Color(0xffF1F6FB),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Assets.svgHome, label: 'Home', index: 0),
              _buildNavItem(icon: Assets.svgShop, label: 'Shop', index: 1),
              const SizedBox(width: 25), // Space for FAB
              _buildNavItem(
                icon: Assets.svgBooking,
                label: 'Bookings',
                index: 3,
              ),
              _buildNavItem(icon: Assets.svgMore, label: 'More', index: 4),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        try {
          Get.find<NavigationController>().setIndex(index);
          Get.back();
        } catch (e) {
          Get.offAll(() => const NavigationMenu());
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            SvgPicture.asset(icon, ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  static Widget buildFloatingButton() {
    return CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: FloatingActionButton(
                  shape: const CircleBorder(
                  ),
                  backgroundColor: Colors.white,
                  elevation: 3,

        onPressed: () {
          try {
            Get.find<NavigationController>().setIndex(2);
            Get.back();
          } catch (e) {
            Get.offAll(() => const NavigationMenu());
          }
        },
        child:  Container(height: 40, width: 40, decoration: BoxDecoration(color: const Color(0xffD9D9D9),shape: BoxShape.circle ), child: SvgPicture.asset(Assets.svgCarttt, fit: BoxFit.scaleDown,),),
      ),
    );
  }
}
