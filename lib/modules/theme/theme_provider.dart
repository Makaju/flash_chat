// import 'package:flutter/material.dart';
//
// class ThemeProvider extends ChangeNotifier {
//   ThemeMode themeMode = ThemeMode.light;
//
//   bool get isDarkMode => themeMode == ThemeMode.dark;
//   void toggleTheme(bool isOn) {
//     themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();
//   }
// }
//
// class MyThemes {
//   static final darkTheme = ThemeData(
//     scaffoldBackgroundColor: Colors.black,
//     colorScheme: const ColorScheme.dark(
//         secondary: Colors.black, onSecondary: Color(0x77424242)),
//     primaryColor: Colors.purple,
//     textTheme: const TextTheme(headline1: TextStyle(color: Colors.white)),
//   );
//   static final lightTheme = ThemeData(
//     scaffoldBackgroundColor: Colors.white,
//     primaryColor: const Color(0xFF1a0c89),
//     colorScheme: const ColorScheme.light(
//         secondary: Colors.white, onSecondary: Colors.white),
//     textTheme: const TextTheme(headline1: TextStyle(color: Colors.black)),
//   );
// }

//New
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme = ThemeData.dark();



  ThemeData dark = ThemeData.dark().copyWith(
    primaryIconTheme: const IconThemeData(color: Colors.white,size: 50,),
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.white,
    dialogBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(
      tertiary: Colors.grey.shade900,
        primary: Colors.purple,
        secondary: Colors.white,
        onPrimaryContainer: const Color(0x77424242),
        onSecondaryContainer:Colors.red.shade400,
        onSecondary: const Color(0x77424242)),
    textTheme: const TextTheme(headline1: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w600),),
  );
  ThemeData light = ThemeData.light().copyWith(
    primaryIconTheme: const IconThemeData(color: Colors.black,size: 50,),
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    dialogBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
        tertiary: Colors.white,
        primary: const Color(0xFF1a0c89),
        onPrimaryContainer: const Color(0xFFFFFFFF),
        secondary: Colors.black,
        onSecondaryContainer:Colors.red.shade900,
        onSecondary: Colors.grey),
    textTheme: const TextTheme(headline1: TextStyle(color: Colors.black, fontSize: 50, fontWeight: FontWeight.w600)),
  );

  ThemeProvider(bool darkThemeOn) {
    _selectedTheme = darkThemeOn ? dark : light;
  }

  Future<void> swapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_selectedTheme == dark) {
      _selectedTheme = light;
      await prefs.setBool("darkTheme", false);
    } else {
      _selectedTheme = dark;
      await prefs.setBool("darkTheme", true);
    }

    notifyListeners();
  }

  ThemeData getTheme() => _selectedTheme;
}

