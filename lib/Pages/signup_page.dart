import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musigo/Pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musigo/Pages/login_page.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _register() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      String userId = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homePage()),
      );
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
    } catch (e) {
      print("Error during registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(39, 45, 45, 1.0),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16,),
            //email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            //password
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            // Sign Up button
            ElevatedButton(
              onPressed: () async {
                await _register(); // Add the await keyword here
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor: Color.fromRGBO(0, 168, 232, 1.0),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 18, color: Color.fromRGBO(246, 248, 255, 1.0)),
              ),
            ),

            SizedBox(height: 16.0,),

            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );;
              },
              child: Text(
                'Already an User? Login',
                style: TextStyle(
                  color: Color.fromRGBO(0, 168, 232, 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
