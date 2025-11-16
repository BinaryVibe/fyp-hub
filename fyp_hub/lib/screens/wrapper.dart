import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_hub/models/app_user.dart';
import 'package:fyp_hub/screens/auth/login_screen.dart';
import 'package:fyp_hub/screens/home/student_home_screen.dart';
import 'package:fyp_hub/screens/profile/create_profile_screen.dart'; // 1. Import new screen
import 'package:fyp_hub/services/user_service.dart'; // 2. Import user service

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService =
        UserService(); // 3. Get instance of user service

    // 4. FIRST STREAM: Listen for Auth changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // If auth is connecting, show loading
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If user IS logged in
        if (authSnapshot.hasData) {
          final user = authSnapshot.data!;

          // 5. SECOND STREAM: User is logged in, now listen for their profile data
          return StreamBuilder<AppUser?>(
            stream: userService.getUserProfileStream(user.uid),
            builder: (context, profileSnapshot) {
              // If profile is connecting, show loading
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // If profile exists
              if (profileSnapshot.hasData) {
                final appUser = profileSnapshot.data!;

                // 6. THE LOGIC: Check if profile is complete
                if (userService.isProfileComplete(appUser)) {
                  // Profile is complete, go home
                  return const StudentHomeScreen();
                } else {
                  // Profile is incomplete, force them to create it
                  return CreateProfileScreen(user: appUser);
                }
              }

              // If profile does not exist (e.g., error), show login
              return const LoginScreen();
            },
          );
        }
        // If user is NOT logged in
        else {
          return const LoginScreen();
        }
      },
    );
  }
}
