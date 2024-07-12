import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rwatrackernew/api/api_service.dart';
import '../constant/app_color.dart';
import '../model/signin/signin_request.dart';
import '../model/signin/signin_response.dart';
import 'bottom_navigation.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      // Navigate to the BottomNavigation screen if the token is available
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const BottomNavigation();
      }));
    }
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _loginApi(context);
    }
  }

  Future<void> _loginApi(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    LoginRequest loginRequest = LoginRequest(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      LoginResponse loginResponse = await ApiService().login(loginRequest);
      print(loginResponse.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginResponse.message)),
      );

      if (loginResponse.status) {
        // Save token and user details in local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginResponse.token);
        await prefs.setString('user_id', loginResponse.id);
        await prefs.setString('user_name', loginResponse.name);
        await prefs.setString('user_email', loginResponse.email);

        // Navigate to the BottomNavigation screen if login is successful
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return const BottomNavigation();
        }));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('An unexpected error occurred. Please try again later.')),
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
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        'Login',
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
                        'Please enter your email and password to log in',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailController,
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
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: secondaryColor,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black54,
                        ), // Change input text color to gray
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return "Please enter a valid email address";
                          }
                          return null;
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
                          hintStyle: TextStyle(color: Colors.grey),
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
                          color: Colors.black54,
                        ), // Change input text color to gray
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.trim().length <= 4) {
                            return 'Password must be at least 4 characters';
                          }
                          return null;
                        },
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
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black54, // Use the color here
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Sign Up',
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}
