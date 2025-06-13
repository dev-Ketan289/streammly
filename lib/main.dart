import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:streammly/navigation_menu.dart';
import 'package:streammly/views/screens/auth_screens/login_screen.dart';
import 'package:streammly/views/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StreammlyApp());
}

class StreammlyApp extends StatelessWidget {
  const StreammlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streammly',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(bodyLarge: TextStyle(fontFamily: 'Open Sans', color: Colors.black), bodyMedium: TextStyle(fontFamily: 'Open Sans', color: Colors.black54)),
      ),
      initialRoute: '/splash',
      routes: {'/splash': (context) => const SplashScreen(), '/login': (context) => LoginScreen(), '/home': (context) => NavigationMenu()},
    );
  }
}
