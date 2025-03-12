import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();

  Future<void> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    if (userCredential.user != null) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Finance Manager", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Create an account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Enter your email to sign up for this app"),
            const SizedBox(height: 20),

            // Email input field
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "email@domain.com",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),

            // Continue button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Continue", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),
            const Text("or", style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            // Google Sign In button
            ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Colors.grey),
              ),
              icon: Image.asset("assets/images/google_logo.png", height: 24),
              label: const Text("Continue with Google", style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 20),
            const Text(
              "By clicking continue, you agree to our Terms of Service and Privacy Policy",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
