import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rwatrackernew/screens/airdrop_screen.dart';
import 'package:rwatrackernew/screens/dashboard_screen.dart';
import 'package:rwatrackernew/screens/game_redem.dart';
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
  final _screens = [
    const DashboardScreen(),
    const PortfolioScreen(),
    const NewsScreen(),
    const VideoScreen(),
    // const GameRedem(),
    const AirDropScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF348f6c),
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize,
                color: _index == 0 ? Colors.white : Colors.white70),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_sharp,
                color: _index == 1 ? Colors.white : Colors.white70),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list,
                color: _index == 2 ? Colors.white : Colors.white70),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection,
                color: _index == 3 ? Colors.white : Colors.white70),
            label: 'Video',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.games,
          //       color: _index == 3 ? Colors.white : Colors.white70),
          //   label: 'Game',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize,
                color: _index == 0 ? Colors.white : Colors.white70),
            label: 'Airdrop',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        iconSize: 24,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        selectedLabelStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(),
      ),
    );
  }
}
