import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/shared/styles/colors.dart';

ThemeData darkmode=ThemeData(
    primarySwatch: myColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blue
    ),
    appBarTheme: AppBarTheme(
        iconTheme:IconThemeData(
            color:  Colors.black
        ),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        systemOverlayStyle:SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor:  Colors.blueGrey,
        ),
        titleTextStyle: TextStyle(
            fontFamily: "Jannah",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white
        )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor:myColor,
        unselectedItemColor: Colors.white,
        elevation: 20,
        backgroundColor: Colors.blueGrey
    ),
    // scaffoldBackgroundColor: HexColor('333739'),
    scaffoldBackgroundColor: Colors.blueGrey,
    textTheme: TextTheme(
bodyText1: TextStyle(
fontWeight: FontWeight.w600,
    fontSize: 18,
    color: Colors.white
),
  subtitle1:    TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: Colors.white,
      height: 1.3
  ),
),
fontFamily: "Jannah",
);

ThemeData lightmode=ThemeData(
    primarySwatch:myColor,
   floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blue
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
        iconTheme:IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle:SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
        ),
      titleTextStyle: TextStyle(
          fontFamily: "Jannah",
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black
      )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor:myColor,
      elevation: 200,
        //backgroundColor: Colors.cyan
    ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: Colors.black
    ),
    subtitle1: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black,
      height: 1.3
    ),
  ),
  fontFamily: "Jannah",
);