import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<Map<String, String>> favoriteSongs;

  FavoritesPage({required this.favoriteSongs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Song Title',
                  labelStyle: TextStyle(color: Colors.purpleAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Artist Name',
                  labelStyle: TextStyle(color: Colors.purpleAccent),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add song to favorites logic here
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: Text('Add Favorite'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
              final song = favoriteSongs[index];
              return ListTile(
                title: Text('${song['title']} - ${song['artist']}', style: TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    // Remove song from favorites here but having errors removing tracks from search page. Tracks you manually add to favorites are removed correctly.
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
