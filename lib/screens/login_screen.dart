import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisibile = false;
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
                    obscureText: !_passwordVisibile,
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
                            _passwordVisibile = !_passwordVisibile;
                          });
                        },
                        icon: _passwordVisibile
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
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
                  )
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
