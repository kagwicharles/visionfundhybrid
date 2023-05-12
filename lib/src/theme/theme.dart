import 'package:flutter/material.dart';

const primaryColor = Color(0xff293178);
const secondaryAccent = Color(0xffE84910);

const pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);

class AppTheme {
  ThemeData appTheme = ThemeData(
    useMaterial3: true,
    pageTransitionsTheme: pageTransitionsTheme,
    // Add this line
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryAccent,
      surfaceTint: Colors.white,
      surface: Colors.white,
      onError: Colors.red,
    ),
    fontFamily: "Montserrat",
    appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        elevation: 2,
        titleTextStyle: TextStyle(fontFamily: "Roboto", fontSize: 20),
        iconTheme: IconThemeData(color: Colors.white)),
    textTheme: const TextTheme(
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
            fontFamily: "Roboto"),
        labelSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        // labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
        labelMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            backgroundColor: MaterialStateProperty.all(primaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //     RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12.0)
            //     )),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(62)))),
    inputDecorationTheme: InputDecorationTheme(
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 217, 217, 217)),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      filled: true,
      fillColor: Colors.grey[50],
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0.0),
            side: MaterialStateProperty.all(
                const BorderSide(color: Colors.white)),
            minimumSize: MaterialStateProperty.all(const Size.fromHeight(62)))),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size(0, 0)),
    )),
    tabBarTheme: const TabBarTheme(
        unselectedLabelColor: Colors.white,
        labelColor: Colors.white,
        labelStyle: TextStyle(fontSize: 16, fontFamily: "Roboto"),
        indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 4.0,
              color: secondaryAccent,
            ),
            insets: EdgeInsets.symmetric(horizontal: 2.0, vertical: 0.0))),
    chipTheme: ChipThemeData(
        side: BorderSide(color: Colors.grey[400]!),
        checkmarkColor: Colors.white,
        padding: const EdgeInsets.all(20),
        showCheckmark: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)))),
    dropdownMenuTheme: const DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 2),
    )),
    buttonTheme:
        const ButtonThemeData(padding: EdgeInsets.symmetric(horizontal: 14)),
    scaffoldBackgroundColor: const Color(0xffF8FAFD),
  );
}
