import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// Color primaryColor = const Color(0xFF941f37);
// Color secondaryColor = const Color(0xFF941f37).withOpacity(.47);
Color primaryColor = const Color(0xFF2864A6);
Color secondaryColor = const Color(0xFF4867B7);
Color backgroundDark = const Color(0xff231F20);
Color backgroundLight = const Color(0xffffffff);

const Color textPrimary = Color(0xff000000);
const Color textSecondary = Color(0xff838383);
Map<int, Color> color = const {
  50: Color.fromRGBO(255, 244, 149, .1),
  100: Color.fromRGBO(255, 244, 149, .2),
  200: Color.fromRGBO(255, 244, 149, .3),
  300: Color.fromRGBO(255, 244, 149, .4),
  400: Color.fromRGBO(255, 244, 149, .5),
  500: Color.fromRGBO(255, 244, 149, .6),
  600: Color.fromRGBO(255, 244, 149, .7),
  700: Color.fromRGBO(255, 244, 149, .8),
  800: Color.fromRGBO(255, 244, 149, .9),
  900: Color.fromRGBO(255, 244, 149, 1),
};
MaterialColor colorCustom = MaterialColor(0XFFFFF495, color);

class CustomTheme {
  static ThemeData light = ThemeData(
    fontFamily: "Montserrat",
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.grey[600],
    cardColor: Colors.grey[100],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[600],
    primaryColorDark: Colors.black,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundLight,
      onBackground: Colors.black,
      surface: backgroundLight,
      onSurface: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(color: backgroundLight),
      iconTheme: IconThemeData(color: backgroundLight),
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: primaryColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      headlineLarge: GoogleFonts.openSans(),
      headlineMedium: GoogleFonts.openSans(),
      headlineSmall: GoogleFonts.openSans(),
      displayLarge: GoogleFonts.openSans(),
      displayMedium: GoogleFonts.openSans(),
      displaySmall: GoogleFonts.openSans(),
      titleLarge: GoogleFonts.publicSans(),
      titleMedium: GoogleFonts.publicSans(fontSize: 20),
      titleSmall: GoogleFonts.publicSans(fontSize: 18),
      bodyLarge: GoogleFonts.openSans(fontSize: 16),
      bodyMedium: GoogleFonts.openSans(fontSize: 14),
      bodySmall: GoogleFonts.openSans(fontSize: 12),
    ),
  );
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundDark,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.black45,
    cardColor: Colors.grey[800],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[200],
    primaryColorDark: Colors.white,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundDark,
      onBackground: Colors.white,
      surface: backgroundDark,
      onSurface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(color: backgroundLight),
      iconTheme: IconThemeData(color: backgroundLight),
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: primaryColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.cinzelDecorative(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      labelMedium: GoogleFonts.cinzelDecorative(),
      headlineLarge: GoogleFonts.openSans(),
      headlineMedium: GoogleFonts.openSans(),
      headlineSmall: GoogleFonts.openSans(),
      displayLarge: GoogleFonts.openSans(),
      displayMedium: GoogleFonts.openSans(),
      displaySmall: GoogleFonts.openSans(),
      titleLarge: GoogleFonts.openSans(),
      titleMedium: GoogleFonts.openSans(),
      titleSmall: GoogleFonts.openSans(),
      bodyLarge: GoogleFonts.openSans(),
      bodyMedium: GoogleFonts.openSans(),
      bodySmall: GoogleFonts.openSans(),
    ),
  );
}
// import 'package:flutter/material.dart';

// Color primaryColor = const Color(0xFFE2E4D9); // 003A9B
// Color secondary = const Color(0xFFFFF6E9);
// Color deepPrimary = const Color(0xFF4B5011);
// Color boxColor = const Color(0xFF455A64);

// Color darkPrimary = const Color(0xFF422D20);
// Color backgroundDark = const Color(0xff231F20);
// Color backgroundLight = const Color(0xffffffff);

// const Color textPrimary = Color(0xff292D32);
// const Color textColor = Color(0xFF404040);
// const Color textSecondary = Color(0xff6B6B6B);
// Map<int, Color> color = const {
//   50: Color.fromRGBO(255, 244, 149, .1),
//   100: Color.fromRGBO(255, 244, 149, .2),
//   200: Color.fromRGBO(255, 244, 149, .3),
//   300: Color.fromRGBO(255, 244, 149, .4),
//   400: Color.fromRGBO(255, 244, 149, .5),
//   500: Color.fromRGBO(255, 244, 149, .6),
//   600: Color.fromRGBO(255, 244, 149, .7),
//   700: Color.fromRGBO(255, 244, 149, .8),
//   800: Color.fromRGBO(255, 244, 149, .9),
//   900: Color.fromRGBO(255, 244, 149, 1),
// };
// MaterialColor colorCustom = MaterialColor(0XFFFFF495, color);

// class CustomTheme {
//   static ThemeData light = ThemeData(
//     brightness: Brightness.light,
//     useMaterial3: true,
//     fontFamily: "Segoeui",
//     scaffoldBackgroundColor: backgroundLight,
//     hintColor: Colors.grey[200],
//     primarySwatch: colorCustom,
//     canvasColor: primaryColor,
//     primaryColorLight: primaryColor,
//     splashColor: primaryColor,
//     shadowColor: Colors.grey[600],
//     cardColor: const Color(0xFFFFFFFF),
//     primaryColor: deepPrimary,
//     dividerColor: const Color(0xFF2A2A2A),
//     primaryColorDark: Colors.black,
//     colorScheme: ColorScheme(
//       brightness: Brightness.light,
//       primary: deepPrimary,
//       onPrimary: deepPrimary,
//       secondary: primaryColor,
//       onSecondary: primaryColor,
//       error: const Color(0xFFCF6679),
//       onError: const Color(0xFFCF6679),
//       background: backgroundLight,
//       onBackground: backgroundLight,
//       surface: backgroundDark,
//       onSurface: backgroundDark,
//     ),
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.white,
//       actionsIconTheme: IconThemeData(
//         color: deepPrimary,
//       ),
//       iconTheme: IconThemeData(
//         color: deepPrimary,
//       ),
//       // systemOverlayStyle: const SystemUiOverlayStyle(
//       //   // Status bar color
//       //   statusBarColor: Colors.white,
//       //   // Status bar brightness (optional)
//       //   statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
//       //   statusBarBrightness: Brightness.light, // For iOS (dark icons)
//       // ),
//     ),
//     typography: Typography.material2021(),
//     // textTheme: TextTheme(
//     //   labelLarge: GoogleFonts.montserrat(
//     //     fontWeight: FontWeight.w400,
//     //     color: textSecondary,
//     //     fontSize: 14.0,
//     //   ),
//     //   displayLarge: GoogleFonts.openSans(fontWeight: FontWeight.w400),
//     //   displayMedium: GoogleFonts.openSans(fontWeight: FontWeight.w400),
//     //   displaySmall: GoogleFonts.openSans(fontWeight: FontWeight.w400),
//     //   titleLarge: GoogleFonts.openSans(fontWeight: FontWeight.w400),
//     //   titleMedium: GoogleFonts.openSans(fontWeight: FontWeight.w400),
//     //   titleSmall: GoogleFonts.openSans(fontWeight: FontWeight.w400),
//     //   bodyLarge: GoogleFonts.openSans(fontWeight: FontWeight.w400),
//     //   bodyMedium: GoogleFonts.openSans(fontWeight: FontWeight.w400),
//     //   bodySmall: GoogleFonts.openSans(fontWeight: FontWeight.w400),
//     // ),
//   );
// }