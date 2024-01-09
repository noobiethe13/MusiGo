import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/genre_tiles.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome $_username',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),
              Text("What's Your Listening Mood Today?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
              SizedBox(height: 20,),
              //Genre Tiles
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    GenreTile(color: Colors.blue, genre: "Pop"),
                    SizedBox(height: 15,),
                    GenreTile(color: Colors.red, genre: "Rock"),
                    SizedBox(height: 15,),
                    GenreTile(color: Colors.orange, genre: "Hip-Hop"),
                    SizedBox(height: 15,),
                    GenreTile(color: Colors.green, genre: "Jazz"),
                    SizedBox(height: 15,),
                    GenreTile(color: Colors.pinkAccent, genre: "Romantic"),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
          ],
          ),
        ),
      ),
    );
  }
}
