import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'mixcloud_service.dart';

class BrowsePage extends StatefulWidget {
  final Function(Map<String, String>) onAddFavorite;

  BrowsePage({required this.onAddFavorite});

  @override
  _BrowsePageState createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final MixcloudService _service = MixcloudService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _results = [];
  bool _loading = false;
  String _error = '';

  void _search() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _loading = true;
      _error = '';
      _results = [];
    });

    try {
      final data = await _service.searchForSongs(_searchController.text.trim());

      if (data != null && data['data'] != null) {
        setState(() {
          _results = data['data'];
        });
      } else {
        setState(() {
          _error = 'No songs found or invalid response format.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading results: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildResults() {
    if (_loading) return Center(child: CircularProgressIndicator());
    if (_error.isNotEmpty) return Center(child: Text(_error, style: TextStyle(color: Colors.white)));
    if (_results.isEmpty) return Center(child: Text('No results. Try searching.', style: TextStyle(color: Colors.white)));

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final item = _results[index];
        final title = item['name'] ?? 'Unknown';
        final artist = item['user']?['name'] ?? 'Unknown Artist';
        final url = item['url'] ?? '';
        final image = item['pictures']?['medium'] ?? 'https://via.placeholder.com/150';

        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(image)),
            title: Text(title),
            subtitle: Text(artist),
            trailing: Wrap(
              spacing: 10,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.purpleAccent),
                  onPressed: () {
                    widget.onAddFavorite({'title': title, 'artist': artist});
                  },
                ),
                IconButton(
                  icon: Icon(Icons.link),
                  onPressed: () => _launchURL('https://www.mixcloud.com$url'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Search Mixcloud songs/mixes',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent),
                      ),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }
}
