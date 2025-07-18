import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/views/screens/home/home_screen.dart';

// Add initialIndex parameter
class NavigationMenu extends StatefulWidget {
  final Set<int> hiddenIndices;
  final bool hideFAB;
  final int initialIndex;
  const NavigationMenu({
    super.key,
    this.hiddenIndices = const {},
    this.hideFAB = false,
    this.initialIndex = 0, // New default param
  });

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  late final NavigationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(NavigationController());

    // Set initialIndex!
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setIndex(widget.initialIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GetBuilder<NavigationController>(builder: (_) => controller.screens[controller.selectedIndex]()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            widget.hideFAB
                ? null
                : GetBuilder<NavigationController>(
                  builder:
                      (_) => CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: FloatingActionButton(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          elevation: 3,
                          onPressed: () {
                            controller.setIndex(2);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(color: const Color(0xffD9D9D9), shape: BoxShape.circle),
                            child: SvgPicture.asset(Assets.svgCarttt, fit: BoxFit.scaleDown),
                          ),
                        ),
                      ),
                ),
        bottomNavigationBar: GetBuilder<NavigationController>(
          builder: (_) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                notchMargin: 5,
                color: const Color(0xffF1F6FB),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (!widget.hiddenIndices.contains(0)) _buildNavItem(theme: Theme.of(context), icon: Assets.svgHome, height: 15, spacing: 4, label: 'Home', index: 0),
                      if (!widget.hiddenIndices.contains(1)) _buildNavItem(theme: Theme.of(context), icon: Assets.svgShop, height: 15, spacing: 4, label: 'Shop', index: 1),
                      if (!widget.hideFAB) const SizedBox(width: 25),
                      if (!widget.hiddenIndices.contains(3)) _buildNavItem(theme: Theme.of(context), icon: Assets.svgBooking, height: 15, spacing: 4, label: 'Bookings', index: 3),
                      if (!widget.hiddenIndices.contains(4)) _buildNavItem(theme: Theme.of(context), icon: Assets.svgMore, height: 5, spacing: 15, label: 'More', index: 4),
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

  Widget _buildNavItem({required ThemeData theme, required String icon, required String label, required int index, required double height, required double spacing}) {
    final isSelected = controller.selectedIndex == index;

    return GestureDetector(
      onTap: () => controller.setIndex(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, height: height, colorFilter: isSelected ? ColorFilter.mode(theme.primaryColor, BlendMode.srcIn) : null),
          SizedBox(height: spacing),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: isSelected ? theme.primaryColor : Colors.black54, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
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
  static Widget buildBottomNav({Set<int> hiddenIndices = const {}, bool hideFAB = false}) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        notchMargin: 5,
        color: const Color(0xffF1F6FB),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (!hiddenIndices.contains(0)) _buildNavItem(icon: Assets.svgHome, label: 'Home', index: 0, height: 15, spacing: 4),
              if (!hiddenIndices.contains(1)) _buildNavItem(icon: Assets.svgShop, label: 'Shop', index: 1, height: 15, spacing: 4),
              if (!hideFAB) const SizedBox(width: 25),
              if (!hiddenIndices.contains(3)) _buildNavItem(icon: Assets.svgBooking, label: 'Bookings', index: 3, height: 15, spacing: 4),
              if (!hiddenIndices.contains(4)) _buildNavItem(icon: Assets.svgMore, label: 'More', index: 4, height: 5, spacing: 15),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildNavItem({required String icon, required String label, required int index, required double height, required double spacing}) {
    return GestureDetector(
      onTap: () {
        // Always rebuild full main nav screen with correct index!
        Get.offAll(() => NavigationMenu(initialIndex: index));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, height: height),
          SizedBox(height: spacing),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  static Widget buildFloatingButton() {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.white,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        elevation: 3,
        onPressed: () {
          // Go to navigation root, tab 2 (cart)
          Get.offAll(() => NavigationMenu(initialIndex: 2));
        },
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(color: const Color(0xffD9D9D9), shape: BoxShape.circle),
          child: SvgPicture.asset(Assets.svgCarttt, fit: BoxFit.scaleDown),
        ),
      ),
    );
  }
}
