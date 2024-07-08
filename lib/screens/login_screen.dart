// login_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/app_color.dart';
import 'bottom_navigation.dart';
import 'signup_screen.dart'; // Import the SignUpScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  // void _onSubmit() {
  //   final formValue = _formKey.currentState!.validate();
  //   if (formValue) {
  //     _formKey.currentState!.save();
  //     _loginApi(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 100)),
                  Image.asset(
                    'assets/rwa_logo.png',
                    width: 400,
                    height: 160,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor, // Use the color here
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Please Login to your account',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: secondaryColor),
                      hintText: 'email@gmail.com',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: secondaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@')) {
                        return " Please enter a valid email address";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _email = newValue.toString();
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: secondaryColor),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: secondaryColor),
                      hintText: '*****',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: secondaryColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: _passwordVisible
                            ? Icon(
                                Icons.visibility,
                                color: secondaryColor,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: secondaryColor,
                              ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length <= 4) {
                        return 'Password must be at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: ((newValue) {
                      _password = newValue!;
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forget Password',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      // onPressed: _onSubmit,
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: ((context) {
                          return const BottomNavigation();
                        })));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            themePrimaryColor, // Use the color here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const SignUpScreen();
                        }),
                      );
                    },
                    child: Text(
                      'Don\'t have an account? Sign Up',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: secondaryColor, // Use the color here
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void _loginApi(BuildContext context) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   LoginRequest loginRequest = LoginRequest();
  //   loginRequest.email = _email.toString();
  //   loginRequest.password = _password.toString();
  //   print('${loginRequest.email} ${loginRequest.password}');
  //   LoginResponse loginResponse = await login(loginRequest);

  //   if (loginResponse.status == 'success') {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     await preferences.setString(
  //         "token", loginResponse.jwtToken!.accessToken as String);

  //     await preferences.setString("password", _password);
  //     await preferences.setBool("loggedIn", true);

  //     // ignore: use_build_context_synchronously
  //     Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
  //       return const BottomNavigation();
  //     })));
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
}
