// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fyp_hub/models/student.dart';
// import 'package:fyp_hub/models/project.dart';
// import 'package:fyp_hub/services/user_service.dart';
// import 'package:fyp_hub/services/project_service.dart';
// import 'package:fyp_hub/screens/projects/project_dashboard.dart';

// class CreateProjectScreen extends StatefulWidget {
//   const CreateProjectScreen({super.key});

//   @override
//   State<CreateProjectScreen> createState() => _CreateProjectScreenState();
// }

// class _CreateProjectScreenState extends State<CreateProjectScreen> {
//   // Services
//   final _auth = FirebaseAuth.instance;
//   final _userService = UserService();
//   final _projectService = ProjectService();

//   // State Variables
//   bool _isLoading = true;
//   bool _isApproved = false;
//   Student? _currentStudent;

//   final _titleController = TextEditingController();
//   final _descController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _checkApprovalStatus();
//   }

//   // 1. CHECK IF APPROVED
//   void _checkApprovalStatus() async {
//     final uid = _auth.currentUser?.uid;
//     if (uid == null) return;

//     final userProfile = await _userService.getUserProfile(uid);

//     if (mounted) {
//       setState(() {
//         if (userProfile is Student) {
//           _currentStudent = userProfile;
//           _isApproved = (userProfile.supervisorId != null && userProfile.supervisorId!.isNotEmpty);
//         }
//         _isLoading = false;
//       });
//     }
//   }

//   // 2. CREATE PROJECT (With Validation!)
//   void _createProject() async {
//     // --- 🛡️ VALIDATION START 🛡️ ---
//     final title = _titleController.text.trim();
//     final desc = _descController.text.trim();

//     if (title.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("⚠️ Please enter a Project Title"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     if (title.length < 5) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("⚠️ Title must be at least 5 characters"),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     if (desc.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("⚠️ Please enter a Description"),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//     // --- VALIDATION END ---

//     if (_currentStudent == null) return;

//     setState(() => _isLoading = true);

//     try {
//       final newProject = Project(
//         projectId: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: title,
//         description: desc,
//         supervisorId: _currentStudent!.supervisorId!,
//         supervisorName: _currentStudent!.supervisorName ?? 'Unknown Supervisor',
//         teamLeadId: _currentStudent!.uid,
//         teamMembers: [
//           {'uid': _currentStudent!.uid, 'name': _currentStudent!.name}
//         ],
//       );

//       await _projectService.createProject(newProject);

//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const ProjectDashboard()),
//         );
//       }
//     } catch (e) {
//       print("Error creating project: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: $e")),
//         );
//       }
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Create Project")),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: _isApproved ? _buildForm() : _buildLockedView(),
//             ),
//     );
//   }

//   Widget _buildLockedView() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
//           const SizedBox(height: 20),
//           const Text(
//             "Project Creation Locked",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             "You must find a supervisor and get their approval\nbefore you can create a project.",
//             textAlign: TextAlign.center,
//             style: TextStyle(color: Colors.grey),
//           ),
//           const SizedBox(height: 30),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Go Back"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildForm() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.green.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.green),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.check_circle, color: Colors.green),
//                 SizedBox(width: 10),
//                 Text("Supervisor Approved", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
//               ],
//             ),
//           ),
//           const SizedBox(height: 30),

//           const Text("Project Title", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 5),
//           TextField(
//             controller: _titleController,
//             decoration: const InputDecoration(
//               hintText: "E.g. AI Traffic Control",
//               border: OutlineInputBorder(),
//               filled: true,
//               fillColor: Colors.white10, // Dark mode friendly
//             ),
//           ),
//           const SizedBox(height: 20),

//           const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 5),
//           TextField(
//             controller: _descController,
//             maxLines: 4,
//             decoration: const InputDecoration(
//               hintText: "Briefly describe the goals of your project...",
//               border: OutlineInputBorder(),
//               filled: true,
//               fillColor: Colors.white10,
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Team Info Card
//           Container(
//             padding: const EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: Colors.grey[800]!),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text("Initial Team", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     const Icon(Icons.person, size: 16, color: Colors.grey),
//                     const SizedBox(width: 5),
//                     Text("${_currentStudent?.name} (Leader)", style: const TextStyle(color: Colors.white)),
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     const Icon(Icons.school, size: 16, color: Colors.grey),
//                     const SizedBox(width: 5),
//                     Text("Supervisor: ${_currentStudent?.supervisorName}", style: const TextStyle(color: Colors.white)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 40),

//           SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               onPressed: _createProject,
//               child: const Text("CREATE PROJECT", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_hub/models/student.dart';
import 'package:fyp_hub/models/project.dart';
import 'package:fyp_hub/services/user_service.dart';
import 'package:fyp_hub/services/project_service.dart';
import 'package:fyp_hub/screens/projects/project_dashboard.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  // Services
  final _auth = FirebaseAuth.instance;
  final _userService = UserService();
  final _projectService = ProjectService();

  // State Variables
  bool _isLoading = true;
  bool _isApproved = false;
  Student? _currentStudent;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkApprovalStatus();
  }

  // 1. CHECK IF APPROVED
  void _checkApprovalStatus() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userProfile = await _userService.getUserProfile(uid);

    if (mounted) {
      setState(() {
        if (userProfile is Student) {
          _currentStudent = userProfile;
          _isApproved =
              (userProfile.supervisorId != null &&
              userProfile.supervisorId!.isNotEmpty);
        }
        _isLoading = false;
      });
    }
  }

  // 2. CREATE PROJECT (With Validation!)
  void _createProject() async {
    // --- 🛡️ VALIDATION START 🛡️ ---
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please enter a Project Title"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (title.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Title must be at least 5 characters"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please enter a Description"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // --- VALIDATION END ---

    if (_currentStudent == null) return;

    setState(() => _isLoading = true);

    try {
      final newProject = Project(
        projectId: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: desc,
        supervisorId: _currentStudent!.supervisorId!,
        supervisorName: _currentStudent!.supervisorName ?? 'Unknown Supervisor',
        teamLeadId: _currentStudent!.uid,
        teamMembers: [
          {'uid': _currentStudent!.uid, 'name': _currentStudent!.name},
        ],
      );

      await _projectService.createProject(newProject);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProjectDashboard()),
        );
      }
    } catch (e) {
      print("Error creating project: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- THEME COLORS ---
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.secondary; // Ice Blue

    return Scaffold(
      appBar: AppBar(title: const Text("Create Project")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: secondaryColor))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: _isApproved ? _buildForm() : _buildLockedView(),
            ),
    );
  }

  Widget _buildLockedView() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 80, color: subtitleColor),
          const SizedBox(height: 20),
          Text(
            "Project Creation Locked",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "You must find a supervisor and get their approval\nbefore you can create a project.",
            textAlign: TextAlign.center,
            style: TextStyle(color: subtitleColor),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: theme.colorScheme.secondary,
            ),
            child: const Text("Go Back"),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Approval Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.5)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  "Supervisor Approved",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Title Input
          Text(
            "Project Title",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: TextStyle(color: primaryColor), // Dark text
            decoration: InputDecoration(
              hintText: "E.g. AI Traffic Control",
              hintStyle: TextStyle(color: subtitleColor.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: subtitleColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: secondaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Description Input
          Text(
            "Description",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
            maxLines: 4,
            style: TextStyle(color: primaryColor), // Dark text
            decoration: InputDecoration(
              hintText: "Briefly describe the goals of your project...",
              hintStyle: TextStyle(color: subtitleColor.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: subtitleColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: secondaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Team Info Card
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white, // UI Change: White card
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: subtitleColor.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Initial Team",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person, size: 18, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "${_currentStudent?.name} (Leader)",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.school, size: 18, color: primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      "Supervisor: ${_currentStudent?.supervisorName}",
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Create Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, // Night Charcoal
                foregroundColor: secondaryColor, // Ice Blue Text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              onPressed: _createProject,
              child: const Text(
                "CREATE PROJECT",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
