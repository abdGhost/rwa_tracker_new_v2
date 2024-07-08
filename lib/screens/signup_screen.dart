// signup_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant/app_color.dart';
import 'bottom_navigation.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;

  // void _onSubmit() {
  //   final formValue = _formKey.currentState!.validate();
  //   if (formValue) {
  //     _formKey.currentState!.save();
  //     _signupApi(context);
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
                      fontSize: 28,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'username',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.blueGrey,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return " Please enter a valid username";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _username = newValue.toString();
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'email@gmail.com',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.blueGrey,
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
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: '*****',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.blueGrey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: _passwordVisible
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.blueGrey,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.blueGrey,
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
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20),
                      border: const OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      hintText: '*****',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.blueGrey,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                        icon: _confirmPasswordVisible
                            ? const Icon(
                                Icons.visibility,
                                color: Colors.blueGrey,
                              )
                            : const Icon(
                                Icons.visibility_off,
                                color: Colors.blueGrey,
                              ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value != _password) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSaved: ((newValue) {
                      _confirmPassword = newValue!;
                    }),
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
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: ((context) {
                            return const BottomNavigation();
                          })));
                        }
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
                    child: Text(
                      'Already have an account? Login',
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

  // void _signupApi(BuildContext context) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   SignUpRequest signUpRequest = SignUpRequest();
  //   signUpRequest.username = _username.toString();
  //   signUpRequest.email = _email.toString();
  //   signUpRequest.password = _password.toString();
  //   print('${signUpRequest.username} ${signUpRequest.email} ${signUpRequest.password}');
  //   SignUpResponse signUpResponse = await signUp(signUpRequest);

  //   if (signUpResponse.status == 'success') {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     await preferences.setString(
  //         "token", signUpResponse.jwtToken!.accessToken as String);

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
