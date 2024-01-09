import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:musigo/Pages/genresongs_page.dart';

class GenreTile extends StatelessWidget {
  final Color color;
  final String genre;

  const GenreTile({required this.color, required this.genre, Key? key}) : super(key: key);

  Future<List<dynamic>?> _fetchGenreDetails() async {
    final dio = Dio();
    final url = 'https://deezerdevs-deezer.p.rapidapi.com/search?q=$genre';
    final headers = {
      'x-rapidapi-key': 'personal_key',
      'x-rapidapi-host': 'deezerdevs-deezer.p.rapidapi.com',
    };

    try {
      final response = await dio.get(
        url,
        options: Options(headers: headers),
      );

      final songs = response.data['data'];
      print('Fetched data: $songs'); // Print fetched data to console
      return songs != null ? List.from(songs) : null;
    } catch (e) {
      print('Error fetching genre details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final songs = await _fetchGenreDetails();
        if (songs != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenreSongs(songs: songs, genreName: "$genre"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to fetch genre details.'),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.all(12),
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            genre,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
