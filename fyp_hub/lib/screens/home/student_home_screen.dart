import 'package:flutter/material.dart';
import 'package:fyp_hub/services/auth_service.dart';
import 'package:fyp_hub/screens/profile/view_profile_screen.dart';
import 'package:fyp_hub/screens/requests/inbox_screen.dart';
import 'package:fyp_hub/screens/projects/create_project_screen.dart'; // IMPORT THIS
import 'package:fyp_hub/screens/marketplace/marketplace_feed.dart';

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
      // --- THIS BUTTON WAS MISSING IN YOUR PASTE ---
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'create_project_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateProjectScreen(),
            ),
          );
        },
        label: const Text("Create Project"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      // ---------------------------------------------
      body: const MarketplaceFeed(),
    );
  }
}