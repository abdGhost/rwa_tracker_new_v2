import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../constant/app_color.dart';
import 'bottom_navigation.dart';
import 'login_screen.dart';

// Model for Signup Request
class SignupRequest {
  final String email;
  final String userName;
  final String password;
  final String confirmPassword;

  SignupRequest({
    required this.email,
    required this.userName,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userName': userName,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}

// Model for Signup Response
class SignupResponse {
  final bool status;
  final String message;

  SignupResponse({
    required this.status,
    required this.message,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

// Function to call the signup API
Future<SignupResponse> signup(SignupRequest request) async {
  final url =
      Uri.parse('https://rwa-f1623a22e3ed.herokuapp.com/api/users/signup');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode(request.toJson()),
  );

  if (response.statusCode == 200) {
    return SignupResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to sign up');
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _username = '';
  String _email = '';
  bool _isLoading = false;

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _signupApi(context);
    }
  }

  Future<void> _signupApi(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    SignupRequest signupRequest = SignupRequest(
      email: _email,
      userName: _username,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    try {
      SignupResponse signupResponse = await signup(signupRequest);

      if (signupResponse.status) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(signupResponse.message)),
        );

        // Navigate to the BottomNavigation screen if signup is successful
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const BottomNavigation();
        }));
      } else {
        // Show error message if signup fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(signupResponse.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      backgroundColor: Color(0xfffFDFAF6),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  Image.asset(
                    'assets/rwa_logo.png',
                    width: 400,
                    height: 160,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create Account',
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor, // Use the color here
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Please fill in the details to create your account',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                      labelText: 'Username',
                      labelStyle: TextStyle(color: secondaryColor),
                      hintText: 'username',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: secondaryColor,
                      ),
                    ),
                    style: const TextStyle(
                        color:
                            Colors.black54), // Change input text color to gray
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a valid username";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _username = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 25,
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
                    style: const TextStyle(
                        color:
                            Colors.black54), // Change input text color to gray
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@')) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _email = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _passwordController,
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
                    style: const TextStyle(
                        color:
                            Colors.black54), // Change input text color to gray
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length <= 4) {
                        return 'Password must be at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: ((newValue) {
                      _passwordController.text = newValue!;
                    }),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
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
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: secondaryColor),
                      hintText: '*****',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: secondaryColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                        icon: _confirmPasswordVisible
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
                    style: const TextStyle(
                        color:
                            Colors.black54), // Change input text color to gray
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSaved: ((newValue) {
                      _confirmPasswordController.text = newValue!;
                    }),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
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
                              'Sign Up',
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
                          return const LoginScreen();
                        }),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black54, // Use the color here
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Login',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: secondaryColor, // Use the color here
                          ),
                        ),
                      ],
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
}
