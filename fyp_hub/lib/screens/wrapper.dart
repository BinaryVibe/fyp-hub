import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fyp_hub/screens/auth/login_screen.dart';
import 'package:fyp_hub/screens/home/student_home_screen.dart'; // baad mei second banda add kare ga

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a StreamBuilder to listen for changes in the auth state
    return StreamBuilder<User?>(
      // 1. Listen to the authStateChanges stream from Firebase
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        // 2. While the stream is connecting, show a loading spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 3. If the snapshot has data, it means the user IS logged in
        if (snapshot.hasData) {
          // Show the main home page (Person 2 will build this)
          return const StudentHomeScreen(); // Placeholder
        }
        // 4. If the snapshot has no data, the user is logged OUT
        else {
          // Show the login page (we will build this next)
          return const LoginScreen();
        }
      },
    );
  }
}
