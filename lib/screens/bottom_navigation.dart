import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rwatrackernew/screens/dashboard_screen.dart';
import 'package:rwatrackernew/screens/news_screen.dart';
import 'package:rwatrackernew/screens/portfolio_screen.dart';
import 'package:rwatrackernew/screens/video_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  var _index = 0;
  final _screen = [
    const DashboardScreen(),
    const PortfolioScreen(),
    const NewsScreen(),
    const VideoScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(20, 20, 22, 1.0),
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize),
            label: 'DashBoard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_sharp),
            label: 'portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Video',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        iconSize: 20,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        selectedLabelStyle: GoogleFonts.roboto(),
        unselectedLabelStyle: GoogleFonts.roboto(),
      ),
    );
  }
}
