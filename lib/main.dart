import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Color.fromRGBO(20, 20, 22, 1.0),
);

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: AppBarTheme(
          foregroundColor: Color.fromRGBO(20, 20, 22, 1.0),
          backgroundColor: Color.fromRGBO(20, 20, 22, 1.0),
        ),
        cardTheme: CardTheme(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(20, 20, 22, 1.0),
          ),
        ),
        textTheme: ThemeData.dark().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
      ),
      // home: const BottomNavigation(),
      home: SplashScreen(),
    );
  }
}
