import 'package:flutter/material.dart';
import 'package:fyp_hub/services/auth_service.dart';
import 'package:fyp_hub/screens/profile/view_profile_screen.dart';
import 'package:fyp_hub/screens/requests/inbox_screen.dart'; 

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // 2. PUT THE NEW BUTTON HERE (Before the other icons)
          IconButton(
            icon: const Icon(Icons.mail_outline), // The Mail Icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InboxScreen(), // Go to Inbox
                ),
              );
            },
          ),
          
          // Existing Profile Button
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewProfileScreen(),
                ),
              );
            },
          ),
          
          // Existing Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: const Center(child: Text('Home Screen (Logged In)')),
    );
  }
}