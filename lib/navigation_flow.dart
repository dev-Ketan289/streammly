import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/coming_soon_page.dart';
import 'package:streammly/services/route_helper.dart';
import 'package:streammly/views/screens/home/home_screen.dart';
import 'package:streammly/views/screens/package/booking/my_bookings.dart';

import 'controllers/home_screen_controller.dart';
import 'services/custom_exit_dailogue.dart';

class NavigationFlow extends StatefulWidget {
  const NavigationFlow({super.key, this.initialIndex});
  static final GlobalKey<NavigationFlowState> navKey =
      GlobalKey<NavigationFlowState>();

  final int? initialIndex;

  @override
  State<NavigationFlow> createState() => NavigationFlowState();
}

class NavigationFlowState extends State<NavigationFlow> {
  ValueNotifier<bool> showBottomBar = ValueNotifier(true);
  final List<bool> bottomBarStack = [true];
  final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
    5,
    (_) => GlobalKey<NavigatorState>(),
  );

  final List<int> _navigationHistory = [0];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Handle initialIndex parameter
    if (widget.initialIndex != null) {
      _currentIndex = widget.initialIndex!;
      _navigationHistory.clear();
      _navigationHistory.add(_currentIndex);
    }

    // Also handle Get.arguments for backward compatibility
    final args = Get.arguments;
    if (args is int) {
      _currentIndex = args;
      _navigationHistory.clear();
      _navigationHistory.add(_currentIndex);
    }
  }

  void pushToCurrentTab(
    Widget page, {
    bool hideBottomBar = false,
    PageTransitionType? transitionType,
    Duration? duration,
    Duration? reverseDuration,
    bool replaceEffect = true, // Enable replacement effect by default
  }) {
    // Prevent rapid taps
    if (bottomBarStack.length > 5) return;

    bottomBarStack.add(!hideBottomBar);
    showBottomBar.value = !hideBottomBar;

    final selectedTransition = transitionType ?? _getContextualTransition();
    final selectedDuration = duration ?? const Duration(milliseconds: 300);
    final selectedReverseDuration =
        reverseDuration ?? const Duration(milliseconds: 300);

    navigatorKeys[_currentIndex].currentState
        ?.push(
          getCustomRoute(
            child: page,
            type: selectedTransition,
            duration: selectedDuration,
            reverseDuration: selectedReverseDuration,
            animate: true,
            replaceEffect: replaceEffect, // Enable smooth replacement
          ),
        )
        .then((_) {
          if (bottomBarStack.isNotEmpty) {
            bottomBarStack.removeLast();
          }
          showBottomBar.value =
              bottomBarStack.isNotEmpty ? bottomBarStack.last : true;
        });
  }

  // Contextual transitions for better UX
  PageTransitionType _getContextualTransition() {
    switch (_currentIndex) {
      case 0: // Home
        return PageTransitionType.rightToLeft;
      case 1: // Shop
        return PageTransitionType.rightToLeft;
      case 2: // Cart
        return PageTransitionType.bottomToTop;
      case 3: // Bookings
        return PageTransitionType.rightToLeft;
      case 4: // More
        return PageTransitionType.fade;
      default:
        return PageTransitionType.rightToLeft;
    }
  }

  Future<void> _handleBackNavigation() async {
    final currentNavigator = navigatorKeys[_currentIndex].currentState!;
    if (currentNavigator.canPop()) {
      currentNavigator.pop();
    } else if (_navigationHistory.length > 1) {
      setState(() {
        _navigationHistory.removeLast();
        _currentIndex = _navigationHistory.last;
      });
    } else {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => const CustomExitDialog(),
      );

      if (shouldExit == true) {
        SystemNavigator.pop();
      }
    }
  }

  void _onTap(int index) {
    if (_currentIndex == index) {
      // Already on the same tab → pop to root
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);

      if (index == 0) {
        // ✅ Refresh Home tab data
        Get.find<HomeController>().refreshHome();
      }

      setState(() {
        _navigationHistory.clear();
        _navigationHistory.add(index);
        _currentIndex = index;
      });
    } else {
      setState(() {
        _currentIndex = index;
        _navigationHistory.add(index);
      });
    }
  }

  Widget _buildOffstageNavigator(int index, Widget child) {
    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: navigatorKeys[index],
        onGenerateRoute: (settings) {
          return getCustomRoute(
            child: child,
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 200),
            animate: false, // No animation for tab switching
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackNavigation();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(0, HomeScreen()),
            _buildOffstageNavigator(1, ShopScreen()),
            _buildOffstageNavigator(2, CartScreen()),
            _buildOffstageNavigator(3, MyBookings()),
            _buildOffstageNavigator(4, MoreScreen()),
          ],
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: showBottomBar,
          builder: (context, value, child) {
            if (!value) return const SizedBox.shrink();
            return CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Colors.white,
                elevation: 3,
                onPressed: () {
                  HapticFeedback.lightImpact(); // Added haptic feedback
                  setState(() {
                    _currentIndex = 2;
                    _navigationHistory.add(2);
                  });
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xffD9D9D9),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    Assets.svgCarttt,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ValueListenableBuilder<bool>(
          valueListenable: showBottomBar,
          builder: (context, value, _) {
            return value
                ? ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: BottomAppBar(
                    shape: const CircularNotchedRectangle(),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    notchMargin: 5,
                    color: const Color(0xffF1F6FB),
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            theme: Theme.of(context),
                            icon: Assets.svgHome,
                            height: 15,
                            spacing: 4,
                            label: 'Home',
                            index: 0,
                          ),
                          _buildNavItem(
                            theme: Theme.of(context),
                            icon: Assets.svgShop,
                            height: 15,
                            spacing: 4,
                            label: 'Shop',
                            index: 1,
                          ),
                          const SizedBox(width: 25),
                          _buildNavItem(
                            theme: Theme.of(context),
                            icon: Assets.svgBooking,
                            height: 15,
                            spacing: 4,
                            label: 'Bookings',
                            index: 3,
                          ),
                          _buildNavItem(
                            theme: Theme.of(context),
                            icon: Assets.svgMore,
                            height: 5,
                            spacing: 15,
                            label: 'More',
                            index: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required ThemeData theme,
    required String icon,
    required String label,
    required int index,
    required double height,
    required double spacing,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact(); // Added haptic feedback
        _onTap(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            height: height,
            colorFilter:
                isSelected
                    ? ColorFilter.mode(theme.primaryColor, BlendMode.srcIn)
                    : null,
          ),
          SizedBox(height: spacing),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isSelected ? theme.primaryColor : Colors.black54,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void switchToTab(int index) {
    setState(() {
      _currentIndex = index;
      _navigationHistory.clear();
      _navigationHistory.add(index);
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    });
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});
  @override
  Widget build(BuildContext context) => const ComingSoonPage();
}

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});
  @override
  Widget build(BuildContext context) => const ComingSoonPage();
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => const ComingSoonPage();
}
