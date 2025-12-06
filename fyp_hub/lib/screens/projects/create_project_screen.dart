import 'package:flutter/material.dart';
import 'package:fyp_hub/screens/projects/project_dashboard.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});
  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  bool isApproved = true; // Toggle to false to see locked screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Project")),
      body: isApproved ? _buildForm() : _buildLockedView(),
    );
  }

  Widget _buildLockedView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text("Project Creation Locked", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text("✅ Supervisor Approved", style: TextStyle(color: Colors.green)),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProjectDashboard()));
              },
              child: const Text("CREATE PROJECT", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}