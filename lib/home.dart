import 'package:flutter/material.dart';
import 'browse_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart'; // Import Profile Page
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation _animation;

  List<Map<String, String>> _favoriteSongs = [];
  late List<Widget> _pages;

  void _addToFavorites(Map<String, String> song) {
    setState(() {
      _favoriteSongs.add(song);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Initialize pages after this
    _pages = [
      Center(child: Text('Welcome to AudioPlane! Your Destination for finding new and exciting music!', style: TextStyle(color: Colors.white, fontSize: 24))),
      BrowsePage(onAddFavorite: _addToFavorites),
      ProfilePage(), // Added Profile Page
      FavoritesPage(favoriteSongs: _favoriteSongs),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audioplane', style: GoogleFonts.righteous(fontSize: 30)),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex],
          if (_selectedIndex == 0)
            Positioned(
              top: 80,
              left: MediaQuery.of(context).size.width / 2 - 120,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(offset: Offset(0, _animation.value), child: child);
                },
                child: Image.asset('assets/logo.png', width: 240, height: 240),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.grey[400],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
