import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => _searchSongs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(Icons.search, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for songs or artists',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults = [];
                });
              },
            ),
          ],
        ),
      ),
      body: _searchResults.isEmpty
          ? Center(
        child: Text(
          'Start searching!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      )
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final song = _searchResults[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4.0,
              child: ListTile(
                title: Text(
                  song['title'] ?? 'Unknown Title',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  song['artist']['name'] ?? 'Unknown Artist',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.play_circle_fill),
                  color: Colors.white,
                  onPressed: () async {
                    final audioPlayer = AudioPlayer();
                    final session = await AudioSession.instance;
                    audioPlayer.playbackEventStream.listen((event) {},
                        onError: (Object e, StackTrace stackTrace) {
                          print('A stream error occurred: $e');
                        });
                    try {
                      await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(
                          "preview_link")));
                    } catch (e) {
                      print("Error loading audio source: $e");
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _searchSongs() async {
    if (_searchController.text.isEmpty) return;

    final dio = Dio();
    final url =
        'https://deezerdevs-deezer.p.rapidapi.com/search?q=${_searchController.text}';
    final headers = {
      'x-rapidapi-key':
      'personal_key',
      'x-rapidapi-host': 'deezerdevs-deezer.p.rapidapi.com',
    };
    try {
      final response =
      await dio.get(url, options: Options(headers: headers));
      setState(() {
        _searchResults = response.data['data'];
      });
    } catch (error) {
      print(error);
      setState(() {
        _searchResults = [];
      });
    }
  }
}
