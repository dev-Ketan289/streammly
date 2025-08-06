import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/views/screens/home/home_screen.dart';
import 'package:streammly/views/screens/package/booking/my_bookings.dart';

import 'services/custom_exit_dailogue.dart';

class NavigationFlow extends StatefulWidget {
  const NavigationFlow({super.key});

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

  void pushToCurrentTab(Widget page, {bool hideBottomBar = false}) {
    bottomBarStack.add(!hideBottomBar);
    showBottomBar.value = !hideBottomBar;

    navigatorKeys[_currentIndex].currentState
        ?.push(MaterialPageRoute(builder: (_) => page))
        .then((_) {
          bottomBarStack.removeLast();
          showBottomBar.value =
              bottomBarStack.isNotEmpty ? bottomBarStack.last : true;
        });
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
      // Double-tap detected: go to root of the tapped index and clear history up to that index
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      setState(() {
        _navigationHistory.clear();
        _navigationHistory.add(index); // Reset to the tapped index
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
          return MaterialPageRoute(
            builder: (context) {
              return child;
            },
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
                : SizedBox.shrink();
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
  Widget build(BuildContext context) {
    return Scaffold(body: Text("data"));
  }
}

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("data"));
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("data"));
  }
}
