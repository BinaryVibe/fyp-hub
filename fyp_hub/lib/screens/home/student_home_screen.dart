// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fyp_hub/screens/marketplace/create_post_screen.dart';
// import 'package:fyp_hub/services/auth_service.dart';
// import 'package:fyp_hub/services/project_service.dart';
// import 'package:fyp_hub/services/user_service.dart';
// import 'package:fyp_hub/models/project.dart';
// import 'package:fyp_hub/models/supervisor.dart';
// import 'package:fyp_hub/screens/profile/view_profile_screen.dart';
// import 'package:fyp_hub/screens/requests/inbox_screen.dart';
// import 'package:fyp_hub/screens/projects/create_project_screen.dart';
// import 'package:fyp_hub/screens/projects/project_dashboard.dart';
// import 'package:fyp_hub/screens/marketplace/marketplace_feed.dart';

// class StudentHomeScreen extends StatefulWidget {
//   const StudentHomeScreen({super.key});

//   @override
//   State<StudentHomeScreen> createState() => _StudentHomeScreenState();
// }

// class _StudentHomeScreenState extends State<StudentHomeScreen>
//     with SingleTickerProviderStateMixin {
//   final AuthService authService = AuthService();
//   final ProjectService projectService = ProjectService();
//   final UserService userService = UserService();
//   final user = FirebaseAuth.instance.currentUser;

//   // --- SPEED DIAL STATE ---
//   bool _isMenuOpen = false;
//   late AnimationController _animationController;
//   late Animation<double> _rotateAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     );
//     _rotateAnimation = Tween<double>(
//       begin: 0.0,
//       end: 0.125,
//     ).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _toggleMenu() {
//     if (_isMenuOpen) {
//       _animationController.reverse();
//     } else {
//       _animationController.forward();
//     }
//     setState(() {
//       _isMenuOpen = !_isMenuOpen;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) return const SizedBox();

//     // Access the current Theme colors to ensure consistency
//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('FYP Hub'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.mail_outline),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const InboxScreen()),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.person_outline),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const ViewProfileScreen(),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.redAccent),
//             onPressed: () async => await authService.signOut(),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           const MarketplaceFeed(),

//           // Professional Dark Overlay
//           if (_isMenuOpen)
//             GestureDetector(
//               onTap: _toggleMenu,
//               child: Container(
//                 color: Colors.black.withOpacity(0.7), // Darker, sleeker overlay
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             ),
//         ],
//       ),

//       // --- THE SPEED DIAL FAB ---
//       floatingActionButton: FutureBuilder(
//         future: userService.getUserProfile(user!.uid),
//         builder: (context, userSnapshot) {
//           if (!userSnapshot.hasData) return const SizedBox();

//           final appUser = userSnapshot.data!;
//           final isSupervisor = appUser is Supervisor;

//           final projectStream = isSupervisor
//               ? projectService.getSupervisorProjectsStream(user!.uid)
//               : projectService.getMyProjectsStream(user!.uid);

//           return StreamBuilder<List<Project>>(
//             stream: projectStream,
//             builder: (context, projectSnapshot) {
//               if (projectSnapshot.hasError) return const SizedBox();

//               bool hasProject =
//                   projectSnapshot.hasData && projectSnapshot.data!.isNotEmpty;

//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   // --- BUTTON 1: CREATE POST (Secondary Action) ---
//                   if (_isMenuOpen) ...[
//                     _buildSpeedDialItem(
//                       context: context,
//                       label: "Create Post",
//                       icon: Icons.edit_note,
//                       // Use Secondary color (e.g. Teal/BlueGrey) for minor actions
//                       backgroundColor: colorScheme.secondaryContainer,
//                       iconColor: colorScheme.onSecondaryContainer,
//                       onTap: () {
//                         _toggleMenu();
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const CreatePostScreen(),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                   ],

//                   // --- BUTTON 2: PROJECT ACTION (Primary Action) ---
//                   if (_isMenuOpen) ...[
//                     _buildSpeedDialItem(
//                       context: context,
//                       label: isSupervisor
//                           ? "View Workspace"
//                           : (hasProject ? "My Workspace" : "Start Project"),
//                       icon: isSupervisor
//                           ? Icons.work_outline
//                           : (hasProject
//                                 ? Icons.dashboard_customize
//                                 : Icons.rocket_launch),
//                       // Use Primary color for the most important action
//                       backgroundColor: colorScheme.primaryContainer,
//                       iconColor: colorScheme.onPrimaryContainer,
//                       onTap: () {
//                         _toggleMenu();
//                         if (isSupervisor) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const ProjectDashboard(),
//                             ),
//                           );
//                         } else {
//                           if (hasProject) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const ProjectDashboard(),
//                               ),
//                             );
//                           } else {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     const CreateProjectScreen(),
//                               ),
//                             );
//                           }
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                   ],

//                   // --- MAIN TOGGLE BUTTON ---
//                   FloatingActionButton(
//                     heroTag: 'main_fab',
//                     onPressed: _toggleMenu,
//                     // Active state uses Error/Grey to indicate "Close", Inactive uses Primary Blue
//                     backgroundColor: _isMenuOpen
//                         ? Colors.grey[800]
//                         : colorScheme.primary,
//                     foregroundColor: _isMenuOpen
//                         ? Colors.white
//                         : colorScheme.onPrimary,
//                     child: RotationTransition(
//                       turns: _rotateAnimation,
//                       child: const Icon(Icons.add, size: 28),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   // --- HELPER: Professional Speed Dial Item ---
//   Widget _buildSpeedDialItem({
//     required BuildContext context,
//     required String label,
//     required IconData icon,
//     required Color backgroundColor,
//     required Color iconColor,
//     required VoidCallback onTap,
//   }) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Label Tag (Dark themed)
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1E1E1E), // Matches your Card background
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey[800]!), // Subtle border
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black45,
//                 blurRadius: 6,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               color: Colors.white, // Crisp white text
//               fontSize: 14,
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         // Mini FAB
//         FloatingActionButton.small(
//           heroTag: label,
//           onPressed: onTap,
//           backgroundColor: backgroundColor,
//           child: Icon(icon, color: iconColor),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_hub/screens/marketplace/create_post_screen.dart';
import 'package:fyp_hub/services/auth_service.dart';
import 'package:fyp_hub/services/project_service.dart';
import 'package:fyp_hub/services/user_service.dart';
import 'package:fyp_hub/models/project.dart';
import 'package:fyp_hub/models/supervisor.dart';
import 'package:fyp_hub/screens/profile/view_profile_screen.dart';
import 'package:fyp_hub/screens/requests/inbox_screen.dart';
import 'package:fyp_hub/screens/projects/create_project_screen.dart';
import 'package:fyp_hub/screens/projects/project_dashboard.dart';
import 'package:fyp_hub/screens/marketplace/marketplace_feed.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen>
    with SingleTickerProviderStateMixin {
  final AuthService authService = AuthService();
  final ProjectService projectService = ProjectService();
  final UserService userService = UserService();
  final user = FirebaseAuth.instance.currentUser;

  // --- SPEED DIAL STATE ---
  bool _isMenuOpen = false;
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees rotation (1/8 of a turn)
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox();

    // Access the current Theme colors
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary; // Night Charcoal
    final secondaryColor = theme.colorScheme.secondary; // Ice Blue
    // final scaffoldColor = theme.scaffoldBackgroundColor; // Snow White

    return Scaffold(
      appBar: AppBar(
        title: const Text('FYP Hub'),
        actions: [
          IconButton(
            icon: Icon(Icons.mail_outline, color: secondaryColor),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InboxScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: secondaryColor),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewProfileScreen(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async => await authService.signOut(),
          ),
        ],
      ),
      body: Stack(
        children: [
          const MarketplaceFeed(),

          // Professional Dark Overlay (Using Night Charcoal with opacity)
          if (_isMenuOpen)
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                // UI Change: Consistent palette overlay
                color: primaryColor.withOpacity(0.85),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
        ],
      ),

      // --- THE SPEED DIAL FAB ---
      floatingActionButton: FutureBuilder(
        future: userService.getUserProfile(user!.uid),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) return const SizedBox();

          final appUser = userSnapshot.data!;
          final isSupervisor = appUser is Supervisor;

          final projectStream = isSupervisor
              ? projectService.getSupervisorProjectsStream(user!.uid)
              : projectService.getMyProjectsStream(user!.uid);

          return StreamBuilder<List<Project>>(
            stream: projectStream,
            builder: (context, projectSnapshot) {
              if (projectSnapshot.hasError) return const SizedBox();

              bool hasProject =
                  projectSnapshot.hasData && projectSnapshot.data!.isNotEmpty;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // --- BUTTON 1: CREATE POST (Secondary Action) ---
                  if (_isMenuOpen) ...[
                    _buildSpeedDialItem(
                      context: context,
                      label: "Create Post",
                      icon: Icons.edit_note,
                      // UI Change: Secondary (Ice Blue) background
                      backgroundColor: secondaryColor,
                      // Icon contrast: Dark on Light
                      iconColor: primaryColor,
                      onTap: () {
                        _toggleMenu();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreatePostScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // --- BUTTON 2: PROJECT ACTION (Primary Action) ---
                  if (_isMenuOpen) ...[
                    _buildSpeedDialItem(
                      context: context,
                      label: isSupervisor
                          ? "View Workspace"
                          : (hasProject ? "My Workspace" : "Start Project"),
                      icon: isSupervisor
                          ? Icons.work_outline
                          : (hasProject
                                ? Icons.dashboard_customize
                                : Icons.rocket_launch),
                      // UI Change: Primary (Night Charcoal) background
                      backgroundColor: primaryColor,
                      // Icon contrast: Light on Dark
                      iconColor: secondaryColor,
                      onTap: () {
                        _toggleMenu();
                        if (isSupervisor) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProjectDashboard(),
                            ),
                          );
                        } else {
                          if (hasProject) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProjectDashboard(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateProjectScreen(),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // --- MAIN TOGGLE BUTTON ---
                  FloatingActionButton(
                    heroTag: 'main_fab',
                    onPressed: _toggleMenu,
                    // UI Change: Grey when open, Night Charcoal when closed
                    backgroundColor: _isMenuOpen
                        ? const Color(0xFF606470) // Slate Grey
                        : primaryColor, // Night Charcoal
                    foregroundColor: _isMenuOpen
                        ? Colors.white
                        : secondaryColor, // Ice Blue
                    child: RotationTransition(
                      turns: _rotateAnimation,
                      child: const Icon(Icons.add, size: 28),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // --- HELPER: Professional Speed Dial Item ---
  Widget _buildSpeedDialItem({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    // UI Change: Label styling using Night Charcoal for high contrast on light bg
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label Tag
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF323643), // Night Charcoal background
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white, // Crisp white text
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Mini FAB
        FloatingActionButton.small(
          heroTag: label,
          onPressed: onTap,
          backgroundColor: backgroundColor,
          child: Icon(icon, color: iconColor),
        ),
      ],
    );
  }
}
