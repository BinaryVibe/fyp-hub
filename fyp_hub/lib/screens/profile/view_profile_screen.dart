import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_hub/models/app_user.dart';
import 'package:fyp_hub/models/student.dart';
import 'package:fyp_hub/models/supervisor.dart';
import 'package:fyp_hub/services/user_service.dart';
import 'package:fyp_hub/screens/profile/edit_profile_screen.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  final UserService _userService = UserService();
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  AppUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load data when the screen is first built
  }

  // Fetch the user's profile from the database
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Get the AppUser object from your service
    final appUser = await _userService.getUserProfile(_uid);

    setState(() {
      _user = appUser;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: _user!),
                ),
              ).then((_) => _loadUserProfile()); // Refresh data after editing
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(
              child: Text(
                'Profile not found.',
                style: TextStyle(color: Colors.red),
              ),
            )
          : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    List<Widget> roleSpecificWidgets = [];

    if (_user is Student) {
      final student = _user as Student;
      roleSpecificWidgets = [
        _buildInfoCard('Domain', student.domain),
        _buildChipList('Skills', student.skills),
      ];
    } else if (_user is Supervisor) {
      final supervisor = _user as Supervisor;
      roleSpecificWidgets = [
        _buildInfoCard('Availability', supervisor.availability),
        _buildChipList('Research Interests', supervisor.interests),
      ];
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Profile Picture
            FadeInDown(
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey_900,
                child: Icon(Icons.person, size: 60, color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
            // Name
            FadeInDown(
              delay: const Duration(milliseconds: 300),
              child: Text(
                _user!.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Email
            FadeInDown(
              delay: const Duration(milliseconds: 400),
              child: Text(
                _user!.email,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            // Role
            FadeInDown(
              delay: const Duration(milliseconds: 500),
              child: Chip(
                label: Text(
                  _user!.role,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
              ),
            ),
            const Divider(color: Colors.grey_800, height: 60),

            ...roleSpecificWidgets,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 600),
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build the chip list
  Widget _buildChipList(String title, List<String> chips) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 700),
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: chips.map((chip) {
                  return Chip(
                    label: Text(
                      chip,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.grey[800],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
