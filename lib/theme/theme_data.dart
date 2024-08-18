import 'package:flutter/material.dart';

class ThemeStyle {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: isDarkTheme ? Colors.black : Colors.white,
          foregroundColor: isDarkTheme ? Colors.white : Colors.black,
        ),
        scaffoldBackgroundColor: isDarkTheme ? Colors.black : Colors.white,
        textTheme: TextTheme(
          titleMedium: TextStyle(
              color: isDarkTheme? Colors.white:Colors.black
          ),
          titleLarge: TextStyle(
              color: isDarkTheme? Colors.white:Colors.black,
            fontWeight: FontWeight.w900
          ),
          titleSmall: TextStyle(
              color: isDarkTheme? Colors.white:Colors.black
          ),
          labelSmall:TextStyle(
              color: isDarkTheme? Colors.white:Colors.black
          ),
          labelMedium: TextStyle(
              color: isDarkTheme? Colors.white:Colors.black
          ),
          headlineLarge: TextStyle(
              color: isDarkTheme? Colors.white:Colors.black
          ),
          headlineMedium: TextStyle(
              color: isDarkTheme? Colors.white:Colors.black
          ),
          headlineSmall: TextStyle(
              color: isDarkTheme? Colors.white:Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        primaryColor: isDarkTheme? Colors.white:Colors.black,
        iconTheme: IconThemeData(
          color:isDarkTheme? Colors.white:Colors.black,

        ),
        colorScheme: ThemeData().colorScheme.copyWith(
              // secondary: isDarkTheme ? Colors.red : Colors.green,
              // onPrimary: isDarkTheme ? Colors.red : Colors.green,
              // inversePrimary: isDarkTheme ? Colors.red : Colors.green,
              // onSecondary: isDarkTheme ? Colors.red : Colors.green,
            ),
         cardColor: isDarkTheme ? Colors.grey : Colors.blue,
        // canvasColor: isDarkTheme ? Colors.red : Colors.green,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              colorScheme: isDarkTheme
                  ? const ColorScheme.dark()
                  : const ColorScheme.light(),
            ));
  }
}
