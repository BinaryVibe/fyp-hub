import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_hub/models/request.dart';
import 'package:fyp_hub/services/request_service.dart';
import 'package:fyp_hub/services/user_service.dart';
import 'package:fyp_hub/services/project_service.dart'; // Import Project Service

class RequestDetailsDialog extends StatelessWidget {
  final Request request;
  const RequestDetailsDialog({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool amISupervisor =
        (currentUser != null &&
        request.receiverId == currentUser.uid &&
        request.type == 'supervisor');

    final requestService = RequestService();
    final userService = UserService();
    final projectService = ProjectService(); // Init Service

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        request.senderName,
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(request.message, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          if (amISupervisor && request.status == 'accepted')
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue.withOpacity(0.1),
              ),
              child: const Text(
                "Meeting Done? Click below to Approve & Unlock Project.",
                style: TextStyle(color: Colors.blue, fontSize: 12),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),

        // --- PENDING STATE ---
        if (request.status == 'pending') ...[
          TextButton(
            onPressed: () async {
              await requestService.updateRequestStatus(
                request.requestId,
                'declined',
              );
              Navigator.pop(context);
            },
            child: const Text("Decline", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              // 1. Mark Request as Accepted
              await requestService.updateRequestStatus(
                request.requestId,
                'accepted',
              );

              // 2. IF THIS IS A TEAMMATE REQUEST, ADD THEM TO PROJECT
              if (request.type == 'teammate' && currentUser != null) {
                try {
                  // A. Find my project (Where I am team lead)
                  // Note: In a real app, we'd handle 'multiple projects' better.
                  final myProjectsSnapshot = await projectService
                      .getMyProjectsStream(currentUser.uid)
                      .first;

                  if (myProjectsSnapshot.isNotEmpty) {
                    final myProject = myProjectsSnapshot.first;

                    // B. Add the sender to the project
                    await projectService.addTeammate(
                      myProject.projectId,
                      request.senderId,
                      request.senderName,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Teammate added to project!"),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Accepted, but you have no project to add them to yet.",
                          ),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  print("Error adding teammate: $e");
                }
              }

              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              "Accept",
            ), // Changed text from "Accept Meeting" to generic "Accept"
          ),
        ],

        // --- SUPERVISOR APPROVAL ---
        if (amISupervisor && request.status == 'accepted')
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () async {
              final myProfile = await userService.getUserProfile(
                currentUser!.uid,
              );
              final myName = myProfile?.name ?? "Unknown Supervisor";

              await userService.updateUserProfile(request.senderId, {
                'supervisorId': currentUser.uid,
                'supervisorName': myName,
              });

              await requestService.updateRequestStatus(
                request.requestId,
                'approved',
              );

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Student Approved! Project Unlocked."),
                  ),
                );
              }
            },
            child: const Text("Approve & Supervise"),
          ),
      ],
    );
  }
}
