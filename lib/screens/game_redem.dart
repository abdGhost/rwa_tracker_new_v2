import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameRedem extends StatefulWidget {
  const GameRedem({super.key});

  @override
  State<GameRedem> createState() => _GameRedemState();
}

class _GameRedemState extends State<GameRedem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffFDFAF6),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Redem Code',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Get more keys',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Each key is a valuable assets',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Play RWA games and earn more keys',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(4), // Makes the container rounded
                    border: Border.all(
                      color: Colors.black12, // Color of the border
                      width: 1, // Width of the border
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: FaIcon(
                          FontAwesomeIcons.key,
                          size: 50,
                          color: Color(0xFF348f6c),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                                4), // Makes the container rounded
                            border: Border.all(
                              color: Colors.black12, // Color of the border
                              width: 1, // Width of the border
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '18',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 120,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(10), // Makes the container rounded
                border: Border.all(
                  color: Colors.black12, // Color of the border
                  width: 1, // Width of the border
                ),
              ),
              child: Column(
                children: [
                  Image.network(
                    "https://res.cloudinary.com/dbtsrjssc/image/upload/v1723464637/final_ion_1_l2eev9.png",
                    width: double.infinity,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'RWA Quiz',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.key,
                          size: 18,
                          color: Color(0xFF348f6c),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              '0/4',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              'received',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 120,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(10), // Makes the container rounded
                border: Border.all(
                  color: Colors.black12, // Color of the border
                  width: 1, // Width of the border
                ),
              ),
              child: Column(
                children: [
                  Image.network(
                    "https://res.cloudinary.com/dbtsrjssc/image/upload/v1723464637/final_ion_1_l2eev9.png",
                    width: double.infinity,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'RWA Quiz',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.key,
                          size: 18,
                          color: Color(0xFF348f6c),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Row(
                          children: [
                            Text(
                              '0/4',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              'received',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
