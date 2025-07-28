import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streammly/controllers/home_screen_controller.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/init.dart';
import 'package:streammly/data/repository/business_settings_repo.dart';
import 'package:streammly/data/repository/category_repo.dart';
import 'package:streammly/data/repository/company_repo.dart';
import 'package:streammly/data/repository/header_repo.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/services/constants.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/auth_screens/login_screen.dart';
import 'package:streammly/views/screens/common/location_screen.dart';
import 'package:streammly/views/screens/common/webview_screen.dart';
import 'package:streammly/views/screens/home/widgets/category/category.dart';
import 'package:streammly/views/screens/package/get_quote_page.dart';

import 'controllers/business_setting_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/company_controller.dart';
import 'controllers/location_controller.dart';
import 'views/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize core data/services
  await Init().initialize();

  // Register global controllers (singleton)
  Get.put(
    BusinessSettingController(
      businessSettingRepo: BusinessSettingRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
  );
  Get.put(
    HomeController(
      homeRepo: HomeRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
    permanent: true,
  );
  Get.put(LocationController(), permanent: true);
  Get.put(
    CategoryController(
      categoryRepo: CategoryRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
    permanent: true,
  );
  Get.put(
    CompanyController(
      companyRepo: CompanyRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
    permanent: true,
  );

  // Ask permissions (optional before launch)
  await requestPermissions();

  runApp(StreammlyApp());
}

Future<void> requestPermissions() async {
  // Request SMS permission
  await Permission.sms.request();

  // Request Location permission
  await Permission.location.request();
}

class StreammlyApp extends StatelessWidget {
  const StreammlyApp({super.key});
  static final GlobalKey<NavigatorState> subnavigator =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: subnavigator,
      navigatorKey: subnavigator,
      debugShowCheckedModeBanner: false,
      title: 'Streammly',
      theme: CustomTheme.light,
      themeMode: ThemeMode.light,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/Location', page: () => const LocationScreen()),
        GetPage(name: '/home', page: () => NavigationFlow()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/getQuote', page: () => GetQuoteScreen()),

        // Promo slider redirection routes
        GetPage(name: '/webview', page: () => const WebViewScreen()),
        GetPage(name: '/category', page: () => CategoryListScreen()),
      ],
    );
  }
}

// // /*----------------------------------------------*/
// class MyApp extends StatelessWidget {
//   static final GlobalKey<NavigatorState> subnavigator =
//       GlobalKey<NavigatorState>();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       key: subnavigator,
//       navigatorKey: subnavigator,
//       home: MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   ValueNotifier<bool> showBottomBar = ValueNotifier(true);
//   final List<bool> bottomBarStack = [true];
//   final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
//     5,
//     (_) => GlobalKey<NavigatorState>(),
//   );

//   final List<int> _navigationHistory = [0];
//   int _currentIndex = 0;

//   void pushToCurrentTab(Widget page, {bool hideBottomBar = false}) {
//     bottomBarStack.add(!hideBottomBar);
//     showBottomBar.value = !hideBottomBar;

//     navigatorKeys[_currentIndex].currentState
//         ?.push(MaterialPageRoute(builder: (_) => page))
//         .then((_) {
//           bottomBarStack.removeLast();
//           showBottomBar.value =
//               bottomBarStack.isNotEmpty ? bottomBarStack.last : true;
//         });
//   }

//   void _handleBackNavigation() {
//     final currentNavigator = navigatorKeys[_currentIndex].currentState!;
//     if (currentNavigator.canPop()) {
//       currentNavigator.pop();
//     } else if (_navigationHistory.length > 1) {
//       setState(() {
//         _navigationHistory.removeLast();
//         _currentIndex = _navigationHistory.last;
//       });
//     } else {
//       log("Hiii");

//       // Exit app: handled automatically by PopScope
//     }
//   }

//   void _onTap(int index) {
//     if (_currentIndex == index) return;
//     setState(() {
//       _currentIndex = index;
//       _navigationHistory.add(index);
//     });
//   }

//   Widget _buildOffstageNavigator(int index, Widget child) {
//     return Offstage(
//       offstage: _currentIndex != index,
//       child: Navigator(
//         key: navigatorKeys[index],
//         onGenerateRoute: (settings) {
//           return MaterialPageRoute(
//             builder: (context) {
//               return child;
//             },
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         if (!didPop) {
//           _handleBackNavigation();
//         }
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             _buildOffstageNavigator(0, HomePage()),
//             _buildOffstageNavigator(1, PayPage()),
//             _buildOffstageNavigator(2, CategoryPage()),
//             _buildOffstageNavigator(3, CartPage()),
//             _buildOffstageNavigator(4, AccountPage()),
//           ],
//         ),
//         bottomNavigationBar: ValueListenableBuilder<bool>(
//           valueListenable: showBottomBar,
//           builder: (context, value, _) {
//             return value
//                 ? BottomNavigationBar(
//                   currentIndex: _currentIndex,
//                   onTap: _onTap,
//                   items: const [
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.home),
//                       label: 'Home',
//                       backgroundColor: Colors.black,
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.payment),
//                       label: 'Pay',
//                       backgroundColor: Colors.black,
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.category),
//                       label: 'Categories',
//                       backgroundColor: Colors.black,
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.shopping_cart),
//                       label: 'Cart',
//                       backgroundColor: Colors.black,
//                     ),
//                     BottomNavigationBarItem(
//                       icon: Icon(Icons.person),
//                       label: 'Account',
//                       backgroundColor: Colors.black,
//                     ),
//                   ],
//                 )
//                 : SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         return InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) {
//                   return SubcategoryPage();
//                 },
//               ),
//             );
//           },
//           child: Text("Category ${index}"),
//         );
//       },
//     );
//   }
// }

// class SubcategoryPage extends StatelessWidget {
//   const SubcategoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         return InkWell(
//           onTap: () {
//             final mainState =
//                 context.findAncestorStateOfType<_MainScreenState>();

//             mainState?.pushToCurrentTab(DetailsPage(), hideBottomBar: true);
//           },
//           child: Text("SubCategory ${index}"),
//         );
//       },
//     );
//   }
// }

// class DetailsPage extends StatelessWidget {
//   const DetailsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () {
//               final mainState =
//                   context.findAncestorStateOfType<_MainScreenState>();
//               mainState?.pushToCurrentTab(WishlistPage(), hideBottomBar: false);
//             },
//             child: Text("Details ${index}"),
//           );
//         },
//       ),
//     );
//   }
// }

// class WishlistPage extends StatelessWidget {
//   const WishlistPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: Center(child: Text("Wishlist Page")));
//   }
// }

// class PayPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TabPageTemplate(title: 'Pay');
//   }
// }

// class CategoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TabPageTemplate(title: 'Category');
//   }
// }

// class CartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TabPageTemplate(title: 'Cart');
//   }
// }

// class AccountPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return TabPageTemplate(title: 'Account');
//   }
// }

// class TabPageTemplate extends StatelessWidget {
//   final String title;
//   const TabPageTemplate({required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('$title Page')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder:
//                     (_) => Scaffold(
//                       appBar: AppBar(title: Text('Inner $title')),
//                       body: Center(child: Text('You are inside $title')),
//                     ),
//               ),
//             );
//           },
//           child: Text('Go deeper into $title'),
//         ),
//       ),
//     );
//   }
// }
