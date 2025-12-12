// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';
// import 'package:fyp_hub/models/project.dart';
// import 'package:fyp_hub/models/milestone.dart';
// import 'package:fyp_hub/services/project_service.dart';
// import 'package:fyp_hub/screens/projects/add_milestone_dialog.dart';
// import 'package:fyp_hub/screens/projects/edit_milestone_dialog.dart';

// class ProjectDashboard extends StatefulWidget {
//   const ProjectDashboard({super.key});

//   @override
//   State<ProjectDashboard> createState() => _ProjectDashboardState();
// }

// class _ProjectDashboardState extends State<ProjectDashboard> {
//   final _projectService = ProjectService();
//   final _uid = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text("Project Workspace"),
//         backgroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: StreamBuilder<List<Project>>(
//         stream: _projectService.getMyProjectsStream(_uid),
//         builder: (context, snapshot) {
//           // A. Loading State
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // B. Error State
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
//           }

//           // C. Fallback for Supervisors
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return _buildSupervisorFallbackStream();
//           }

//           // D. Found Project (Student View)
//           final project = snapshot.data!.first;
//           return _buildDashboardUI(project, false);
//         },
//       ),
//     );
//   }

//   // Helper: Supervisor View Logic
//   Widget _buildSupervisorFallbackStream() {
//     return StreamBuilder<List<Project>>(
//       stream: _projectService.getSupervisorProjectsStream(_uid),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(
//             child: Text("No active projects found.", style: TextStyle(color: Colors.grey)),
//           );
//         }
//         final project = snapshot.data!.first;
//         return _buildDashboardUI(project, true);
//       },
//     );
//   }

//   Widget _buildDashboardUI(Project project, bool isSupervisor) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --- ✨ BEAUTIFUL HEADER CARD ✨ ---
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.blue.shade900, Colors.purple.shade900],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.withOpacity(0.2),
//                     blurRadius: 15,
//                     offset: const Offset(0, 8),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(Icons.rocket_launch, color: Colors.white, size: 24),
//                       ),
//                       const SizedBox(width: 15),
//                       Expanded(
//                         child: Text(
//                           project.title,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     project.description,
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.85),
//                       fontSize: 14,
//                       height: 1.5, // Better readability
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   // Team Badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.group, color: Colors.white70, size: 14),
//                         const SizedBox(width: 5),
//                         Text(
//                           "Team Leader: ${project.teamMembers.isNotEmpty ? project.teamMembers[0]['name'] : 'Unknown'}",
//                           style: const TextStyle(color: Colors.white70, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // ------------------------------------

//             const SizedBox(height: 30),

//             // MILESTONES HEADER
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Milestones", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//                 if (isSupervisor)
//                   IconButton(
//                     icon: const Icon(Icons.add_task, color: Colors.blue),
//                     onPressed: () => _showAddMilestone(project.projectId),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 15),

//             // REAL MILESTONE STREAM
//             StreamBuilder<List<Milestone>>(
//               stream: _projectService.getMilestonesStream(project.projectId),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return const LinearProgressIndicator();

//                 final milestones = snapshot.data!;

//                 // EMPTY STATE
//                 if (milestones.isEmpty) {
//                   return Container(
//                     padding: const EdgeInsets.all(30),
//                     margin: const EdgeInsets.only(top: 20),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[900],
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.white10),
//                     ),
//                     width: double.infinity,
//                     child: Column(
//                       children: [
//                         Icon(Icons.flag_outlined, size: 50, color: Colors.blue[300]),
//                         const SizedBox(height: 15),
//                         const Text(
//                           "No Milestones Set",
//                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           isSupervisor
//                               ? "Click the + button above to assign the first task."
//                               : "Waiting for your supervisor to assign tasks.",
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(color: Colors.grey, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: milestones.length,
//                   itemBuilder: (context, index) {
//                     final m = milestones[index];
//                     return Card(
//                       color: Colors.grey[900],
//                       margin: const EdgeInsets.only(bottom: 10),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       child: ListTile(
//                         leading: Icon(
//                           m.status == 'Approved' ? Icons.check_circle : Icons.radio_button_unchecked,
//                           color: m.status == 'Approved' ? Colors.green : Colors.grey,
//                         ),
//                         title: Text(
//                           m.title,
//                           style: TextStyle(
//                             color: Colors.white,
//                             decoration: m.status == 'Approved' ? TextDecoration.lineThrough : null,
//                             fontWeight: FontWeight.bold,
//                           )
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.only(top: 5),
//                           child: Text(
//                             "Deadline: ${DateFormat('MMM dd').format(m.deadline.toDate())}",
//                             style: TextStyle(color: Colors.blue[200], fontSize: 12)
//                           ),
//                         ),
//                         trailing: isSupervisor
//                           ? IconButton(
//                               icon: const Icon(Icons.edit, color: Colors.white70),
//                               onPressed: () => _showEditMilestone(project.projectId, m),
//                             )
//                           : null,
//                       ),
//                     );
//                   },
//                 );
//               }
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddMilestone(String projectId) async {
//     final result = await showDialog<Milestone>(
//       context: context,
//       builder: (ctx) => const AddMilestoneDialog(),
//     );
//     if (result != null) {
//       await _projectService.addMilestone(projectId, result);
//     }
//   }

//   void _showEditMilestone(String projectId, Milestone m) async {
//     final result = await showDialog<Milestone>(
//       context: context,
//       builder: (ctx) => EditMilestoneDialog(milestone: m),
//     );
//     if (result != null) {
//       await _projectService.updateMilestone(projectId, result);
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fyp_hub/models/project.dart';
import 'package:fyp_hub/models/milestone.dart';
import 'package:fyp_hub/services/project_service.dart';
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
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Project Workspace", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.primary,
      ),
      body: StreamBuilder<List<Project>>(
        stream: _projectService.getMyProjectsStream(_uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: secondaryColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // 1. If I am a Student (Team Lead/Member) -> Show My Single Project
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final project = snapshot.data!.first;
            return ProjectDetailView(project: project, isSupervisor: false);
          }

          // 2. If I am NOT a student, check if I am a Supervisor
          return _buildSupervisorView();
        },
      ),
    );
  }

  Widget _buildSupervisorView() {
    return StreamBuilder<List<Project>>(
      stream: _projectService.getSupervisorProjectsStream(_uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final projects = snapshot.data ?? [];

        if (projects.isEmpty) {
          return const Center(
            child: Text("No active projects found.", style: TextStyle(color: Colors.grey)),
          );
        }

        // --- SUPERVISOR: SHOW LIST OF PROJECTS ---
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Navigate to Detail View for THIS project
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        // ✅ FIX: Use generic title to avoid duplication with the Header Card
                        appBar: AppBar(
                          title: const Text("Project Workspace", style: TextStyle(fontWeight: FontWeight.bold)),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        body: ProjectDetailView(project: project, isSupervisor: true),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.folder_shared, color: Colors.purple, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              project.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            // Team Lead Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Lead: ${project.teamMembers.isNotEmpty ? project.teamMembers[0]['name'] : 'Unknown'}",
                                style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// --- REUSABLE DETAIL VIEW (The "Rocket" Dashboard) ---
class ProjectDetailView extends StatefulWidget {
  final Project project;
  final bool isSupervisor;

  const ProjectDetailView({super.key, required this.project, required this.isSupervisor});

  @override
  State<ProjectDetailView> createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> {
  final _projectService = ProjectService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, const Color(0xFF2C3E50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(Icons.rocket_launch, color: secondaryColor, size: 24),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          widget.project.title,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.project.description,
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.group, color: Colors.white70, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          "Team: ${widget.project.teamMembers.map((m) => m['name']).join(', ')}",
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // MILESTONES HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Milestones", style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
                if (widget.isSupervisor)
                  IconButton(
                    icon: Icon(Icons.add_task, color: secondaryColor),
                    onPressed: () => _showAddMilestone(context, widget.project.projectId),
                  ),
              ],
            ),
            const SizedBox(height: 15),

            // STREAM MILESTONES
            StreamBuilder<List<Milestone>>(
              stream: _projectService.getMilestonesStream(widget.project.projectId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator(color: secondaryColor);
                final milestones = snapshot.data!;

                if (milestones.isEmpty) {
                  return _buildEmptyState(widget.isSupervisor, subtitleColor, primaryColor);
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: milestones.length,
                  itemBuilder: (context, index) {
                    final m = milestones[index];
                    return _buildMilestoneCard(context, m, widget.project.projectId, widget.isSupervisor, primaryColor, subtitleColor);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSupervisor, Color subtitleColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(30),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: subtitleColor.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      width: double.infinity,
      child: Column(
        children: [
          Icon(Icons.flag_outlined, size: 50, color: subtitleColor),
          const SizedBox(height: 15),
          Text("No Milestones Set", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            isSupervisor ? "Click the + button above to assign the first task." : "Waiting for your supervisor to assign tasks.",
            textAlign: TextAlign.center,
            style: TextStyle(color: subtitleColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneCard(BuildContext context, Milestone m, String projectId, bool isSupervisor, Color primaryColor, Color subtitleColor) {
    IconData icon;
    Color color;
    if (m.status == 'Approved') {
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (m.status == 'In Progress') {
      icon = Icons.hourglass_bottom_rounded;
      color = Colors.orange;
    } else {
      icon = Icons.radio_button_unchecked;
      color = Colors.grey;
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: subtitleColor.withOpacity(0.1))),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          m.title,
          style: TextStyle(
            color: primaryColor,
            decoration: m.status == 'Approved' ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Text("Deadline: ${DateFormat('MMM dd').format(m.deadline.toDate())}", style: TextStyle(color: subtitleColor, fontSize: 12)),
              const Spacer(),
              Text(m.status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        trailing: isSupervisor
            ? IconButton(
                icon: Icon(Icons.edit, color: subtitleColor),
                onPressed: () => _showEditMilestone(context, projectId, m),
              )
            : null,
      ),
    );
  }

  void _showAddMilestone(BuildContext context, String projectId) async {
    final result = await showDialog<Milestone>(context: context, builder: (ctx) => const AddMilestoneDialog());
    if (result != null) {
      await _projectService.addMilestone(projectId, result);
    }
  }

  void _showEditMilestone(BuildContext context, String projectId, Milestone m) async {
    final result = await showDialog<Milestone>(context: context, builder: (ctx) => EditMilestoneDialog(milestone: m));
    if (result != null) {
      await _projectService.updateMilestone(projectId, result);
    }
  }
}