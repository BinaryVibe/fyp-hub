import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fyp_hub/models/project.dart';
import 'package:fyp_hub/models/milestone.dart';
import 'package:fyp_hub/services/project_service.dart'; // 1. Using Real Service
import 'package:fyp_hub/screens/projects/add_milestone_dialog.dart';
import 'package:fyp_hub/screens/projects/edit_milestone_dialog.dart';

class ProjectDashboard extends StatefulWidget {
  const ProjectDashboard({super.key});

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  final _projectService = ProjectService();
  final _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Project Workspace"), 
        backgroundColor: Colors.black,
      ),
      // 2. LISTEN TO LIVE DATA (Not MockData)
      body: StreamBuilder<List<Project>>(
        stream: _projectService.getMyProjectsStream(_uid),
        builder: (context, snapshot) {
          // A. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // B. Error State
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }

          // C. Logic: If not found as Student, try checking if I am a Supervisor
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildSupervisorFallbackStream();
          }

          // D. Found Project! (I am the Team Lead)
          final project = snapshot.data!.first;
          return _buildDashboardUI(project, false); // isSupervisor = false
        },
      ),
    );
  }

  // Helper: Supervisor View Logic
  Widget _buildSupervisorFallbackStream() {
    return StreamBuilder<List<Project>>(
      stream: _projectService.getSupervisorProjectsStream(_uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No active projects found.", style: TextStyle(color: Colors.grey)),
          );
        }
        // Supervisors see the first project found (for now)
        final project = snapshot.data!.first;
        return _buildDashboardUI(project, true); // isSupervisor = true
      },
    );
  }

  Widget _buildDashboardUI(Project project, bool isSupervisor) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3. REAL TITLE & DESCRIPTION
            Text(
              project.title, 
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            Text(
              project.description, 
              style: const TextStyle(color: Colors.white70)
            ),
            const SizedBox(height: 25),
            
            // 4. MILESTONES SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Milestones", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                
                // Only Supervisors can see the "Add" button
                if (isSupervisor)
                  IconButton(
                    icon: const Icon(Icons.add_task, color: Colors.blue),
                    onPressed: () => _showAddMilestone(project.projectId),
                  ),
              ],
            ),
            const SizedBox(height: 15),

            // 5. REAL MILESTONE STREAM
            StreamBuilder<List<Milestone>>(
              stream: _projectService.getMilestonesStream(project.projectId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LinearProgressIndicator();
                
                final milestones = snapshot.data!;
                if (milestones.isEmpty) {
                  return const Text("No milestones yet.", style: TextStyle(color: Colors.grey));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: milestones.length,
                  itemBuilder: (context, index) {
                    final m = milestones[index];
                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: Icon(
                          m.status == 'Approved' ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: m.status == 'Approved' ? Colors.green : Colors.grey,
                        ),
                        title: Text(
                          m.title, 
                          style: TextStyle(
                            color: Colors.white,
                            decoration: m.status == 'Approved' ? TextDecoration.lineThrough : null
                          )
                        ),
                        subtitle: Text(
                          "Deadline: ${DateFormat('MMM dd').format(m.deadline.toDate())}", 
                          style: const TextStyle(color: Colors.grey)
                        ),
                        // Only Supervisors can Edit/Approve
                        trailing: isSupervisor 
                          ? IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditMilestone(project.projectId, m),
                            )
                          : null,
                      ),
                    );
                  },
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIC METHODS ---

  void _showAddMilestone(String projectId) async {
    final result = await showDialog<Milestone>(
      context: context,
      builder: (ctx) => const AddMilestoneDialog(),
    );
    if (result != null) {
      await _projectService.addMilestone(projectId, result);
    }
  }

  void _showEditMilestone(String projectId, Milestone m) async {
    final result = await showDialog<Milestone>(
      context: context,
      builder: (ctx) => EditMilestoneDialog(milestone: m),
    );
    if (result != null) {
      await _projectService.updateMilestone(projectId, result);
    }
  }
}