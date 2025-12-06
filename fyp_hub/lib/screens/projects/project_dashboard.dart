import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fyp_hub/models/project.dart';
import 'package:fyp_hub/models/milestone.dart';
import 'package:fyp_hub/shared/mock_data.dart';
import 'package:fyp_hub/screens/projects/add_milestone_dialog.dart';
import 'package:fyp_hub/screens/projects/edit_milestone_dialog.dart';

class ProjectDashboard extends StatefulWidget {
  const ProjectDashboard({super.key});

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
  // TOGGLE THIS: Change to 'false' to test Student View!
  bool amISupervisor = false; 

  final Project _project = MockData.myProject;
  final List<Milestone> _milestones = MockData.myMilestones;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Project"),
        backgroundColor: Colors.black,
        actions: [
          // 1. ADD MILESTONE BUTTON (Supervisor Only)
          if (amISupervisor)
            IconButton(
              icon: const Icon(Icons.add_task, color: Colors.blue),
              onPressed: () async {
                // Open Add Dialog
                final newMilestone = await showDialog<Milestone>(
                  context: context,
                  builder: (context) => const AddMilestoneDialog(),
                );

                // Add to list if created
                if (newMilestone != null) {
                  setState(() {
                    _milestones.add(newMilestone);
                  });
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Info
              Text(_project.title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(_project.description, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 25),
              
              // Milestones Header
              const Text("Milestones", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              // Milestones List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _milestones.length,
                itemBuilder: (context, index) {
                  final m = _milestones[index];
                  return Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      title: Text(
                        m.title, 
                        style: TextStyle(
                          color: Colors.white,
                          decoration: m.status == 'Approved' ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(
                        "Deadline: ${DateFormat('MMM dd').format(m.deadline.toDate())}\nStatus: ${m.status}", 
                        style: const TextStyle(color: Colors.grey)
                      ),
                      isThreeLine: true,
                      // 2. EDIT BUTTON (Supervisor Only)
                      trailing: amISupervisor 
                        ? IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              // Open Edit Dialog
                              final updatedMilestone = await showDialog<Milestone>(
                                context: context,
                                builder: (context) => EditMilestoneDialog(milestone: m),
                              );

                              // Update list if changed
                              if (updatedMilestone != null) {
                                setState(() {
                                  _milestones[index] = updatedMilestone;
                                });
                              }
                            },
                          )
                        : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}