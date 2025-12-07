import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_hub/services/auth_service.dart';
import 'package:fyp_hub/services/project_service.dart';
import 'package:fyp_hub/services/user_service.dart'; // 1. Add User Service
import 'package:fyp_hub/models/project.dart';
import 'package:fyp_hub/models/supervisor.dart'; // 2. To check role
import 'package:fyp_hub/screens/profile/view_profile_screen.dart';
import 'package:fyp_hub/screens/requests/inbox_screen.dart';
import 'package:fyp_hub/screens/projects/create_project_screen.dart';
import 'package:fyp_hub/screens/projects/project_dashboard.dart';
import 'package:fyp_hub/screens/marketplace/marketplace_feed.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final ProjectService projectService = ProjectService();
    final UserService userService = UserService();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return const SizedBox(); // Safety check

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InboxScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: const MarketplaceFeed(),

      // 3. SMART FAB: Checks Role FIRST, then Project status
      floatingActionButton: FutureBuilder(
        future: userService.getUserProfile(user.uid),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) return const SizedBox(); // Hide while loading

          final appUser = userSnapshot.data!;
          final isSupervisor = appUser is Supervisor; // Check Role

          // Decide which stream to listen to based on role
          final projectStream = isSupervisor
              ? projectService.getSupervisorProjectsStream(user.uid)
              : projectService.getMyProjectsStream(user.uid);

          return StreamBuilder<List<Project>>(
            stream: projectStream,
            builder: (context, projectSnapshot) {
              bool hasProject =
                  projectSnapshot.hasData && projectSnapshot.data!.isNotEmpty;

              // --- LOGIC FOR SUPERVISORS ---
              if (isSupervisor) {
                if (hasProject) {
                  // Supervisor has a project -> Show Dashboard Button
                  return FloatingActionButton.extended(
                    heroTag: 'sup_project_fab',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProjectDashboard()),
                      );
                    },
                    label: const Text("View Workspace"),
                    icon: const Icon(Icons.work),
                    backgroundColor: Colors.purple, // Purple for Supervisors
                  );
                } else {
                  // Supervisor has NO project -> Show Nothing (Wait for students)
                  return const SizedBox();
                }
              }

              // --- LOGIC FOR STUDENTS ---
              else {
                return FloatingActionButton.extended(
                  heroTag: 'stu_project_fab',
                  onPressed: () {
                    if (hasProject) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProjectDashboard()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateProjectScreen()),
                      );
                    }
                  },
                  label: Text(hasProject ? "My Project" : "Create Project"),
                  icon: Icon(hasProject ? Icons.dashboard : Icons.add),
                  backgroundColor: hasProject ? Colors.green : Colors.blue,
                );
              }
            },
          );
        },
      ),
    );
  }
}