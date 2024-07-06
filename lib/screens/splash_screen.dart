// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  Future<void> _checkIsLogin() async {
    String? token;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token');
    print('token -- $token');
  }

  void navigatedTo() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // if (preferences.getBool('loggedIn') == true) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: ((context) => const BottomNavigation()),
    //     ),
    //   );
    // } else {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: ((context) => const LoginScreen()),
    //     ),
    //   );
    // }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => const LoginScreen()),
      ),
    );
  }

  startTimer() {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigatedTo);
  }

  @override
  void initState() {
    super.initState();
    _checkIsLogin();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 300).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: _animation.value,
          width: _animation.value,
          child: Image.asset(
            'assets/rwa_logo.png',
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}