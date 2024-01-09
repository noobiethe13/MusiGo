import 'package:flutter/material.dart';
import 'package:musigo/Pages/playlists_page.dart';
import 'package:musigo/Pages/search_page.dart';
import 'package:musigo/Pages/welcome_page.dart';

class homePage extends StatefulWidget {
  homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedindex = 0;

  void navigatenavbar(int index){
    setState(() {
      _selectedindex = index;
    });
  }

  final List<Widget> pages = [
    const WelcomePage(),
    const SearchPage(),
    const PlaylistsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 6.0,
        shadowColor: Colors.grey,
        backgroundColor: Color.fromRGBO(35, 206, 107, 1.0),
        title: Center(
          child: Text('MusiGo',
            style: TextStyle(
              color: Color.fromRGBO(246, 248, 255, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
         currentIndex: _selectedindex,
        onTap: navigatenavbar,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.transparent,
        items: [
          //homepage
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
          //searchpage
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          //playlistspage
          BottomNavigationBarItem(icon: Icon(Icons.library_music_rounded), label: 'Playlists')
        ],
      ),
      body: pages[_selectedindex],
    );
  }
}

