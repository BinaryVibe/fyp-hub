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
  bool _isApproved = false; // Now determined by real database data
  Student? _currentStudent;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkApprovalStatus();
  }

  // 1. CHECK IF APPROVED (Real Database Check)
  void _checkApprovalStatus() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Fetch user profile
    final userProfile = await _userService.getUserProfile(uid);
    
    if (mounted) {
      setState(() {
        if (userProfile is Student) {
          _currentStudent = userProfile;
          // You are approved ONLY IF you have a supervisorId in your profile
          _isApproved = (userProfile.supervisorId != null && userProfile.supervisorId!.isNotEmpty);
        }
        _isLoading = false;
      });
    }
  }

  // 2. CREATE PROJECT (Real Database Write)
  void _createProject() async {
    if (_titleController.text.isEmpty) return;
    if (_currentStudent == null) return;

    setState(() => _isLoading = true);

    try {
      // Build the Project Object
      final newProject = Project(
        projectId: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        // These come from your Student Profile (set during approval)
        supervisorId: _currentStudent!.supervisorId!, 
        supervisorName: _currentStudent!.supervisorName ?? 'Unknown Supervisor',
        teamLeadId: _currentStudent!.uid,
        teamMembers: [
          {'uid': _currentStudent!.uid, 'name': _currentStudent!.name}
        ],
      );

      // Save to Firestore
      await _projectService.createProject(newProject);

      // Navigate to Dashboard
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProjectDashboard()),
        );
      }
    } catch (e) {
      print("Error creating project: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Project")),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              // Show Form if Approved, otherwise show Lock
              child: _isApproved ? _buildForm() : _buildLockedView(),
            ),
    );
  }

  Widget _buildLockedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            "Project Creation Locked",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "You must find a supervisor and get their approval\nbefore you can create a project.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Go Back"),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("✅ Supervisor Approved", style: TextStyle(color: Colors.green)),
          const SizedBox(height: 20),
          
          const Text("Project Title", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: "Enter unique title"),
          ),
          const SizedBox(height: 20),

          const Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextField(
            controller: _descController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: "Describe your project..."),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Your Team (Auto-filled)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(height: 5),
                Text("1. ${_currentStudent?.name} (Leader)", style: const TextStyle(color: Colors.black87)),
                Text("2. Supervisor: ${_currentStudent?.supervisorName}", style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _createProject,
              child: const Text("CREATE PROJECT", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}