import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class GenreSongs extends StatelessWidget {
  final List<dynamic> songs;
  final String genreName;

  const GenreSongs({required this.songs, required this.genreName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 6.0,
        shadowColor: Colors.grey,
        backgroundColor: Color.fromRGBO(35, 206, 107, 1.0),
        title: Center(
          child: Text(
            'MusiGo',
            style: TextStyle(
              color: Color.fromRGBO(246, 248, 255, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Center(
                child: Text(
                  'Songs for $genreName Genre',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final title = song['title'] ?? 'Unknown Title';
                  final artistName = song['artist']?['name'] ?? 'Unknown Artist';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      color: Color.fromRGBO(71, 149, 159, 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4.0,
                      child: ListTile(
                        title: Text(
                          title,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          artistName,
                          style: TextStyle(color: Colors.white),
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
                                  "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
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
            ),
          ],
        ),
      ),
    );
  }
}