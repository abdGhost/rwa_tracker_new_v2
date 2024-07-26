import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AirDropScreen extends StatefulWidget {
  const AirDropScreen({super.key});

  @override
  State<AirDropScreen> createState() => _AirDropScreenState();
}

class _AirDropScreenState extends State<AirDropScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffFDFAF6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Airdrop',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/rwa-mobile-login-icon.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Airdrop Tasks',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Listing is on its ways. Tasks will appear below.\nComplete them to participate in the Airdrop',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Tasks List',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    // color: Colors.white,
                    // color: Colors.red,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color.fromARGB(
                            255, 214, 214, 214), // Set border color
                        width: 1,
                      ), // Set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)), // Set rounded corner radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.gif_rounded,
                            ),
                            title: Text('Follow Our X account'),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.commit,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text('1200'),
                              ],
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  backgroundColor:
                                      Color.fromARGB(255, 254, 245, 245),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Stack(
                                      children: [
                                        Container(
                                          height: 420,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.xTwitter,
                                                  size: 100,
                                                  color: Colors.black54,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Follow our X account',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Center(
                                                  child: SizedBox(
                                                    width:
                                                        140, // Set the width you desire
                                                    height:
                                                        40, // Set the height you desire
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // Submit the coin data
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        foregroundColor:
                                                            Colors.white,
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF348f6c),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  15.0), // Set your desired border radius here
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        'Join',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.coins,
                                                      color: Colors.yellow,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '+10000',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black87,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 20,
                                          top: 20,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
