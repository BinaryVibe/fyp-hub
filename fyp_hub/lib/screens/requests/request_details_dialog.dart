import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import this
import 'package:fyp_hub/models/request.dart';
import 'package:fyp_hub/services/request_service.dart'; // Import this
import 'package:fyp_hub/services/project_service.dart'; // Import this (for creating projects later)

class RequestDetailsDialog extends StatelessWidget {
  final Request request;
  const RequestDetailsDialog({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    // 1. Determine Role Dynamically (Mock logic removed)
    // In a real app, we might check the user's profile doc, 
    // but for now, we can infer role by the request type sent TO us.
    // If I received a 'supervisor' request, I am acting as a supervisor.
    final bool amISupervisor = request.type == 'supervisor';
    final requestService = RequestService();

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(request.senderName, style: const TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            request.message,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          
          // Gate Logic: Show only if accepted & I am supervisor
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
        // CLOSE BUTTON
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),

        // 2. ACCEPT / DECLINE BUTTONS (If Pending)
        if (request.status == 'pending') ...[
          TextButton(
            onPressed: () async {
              await requestService.updateRequestStatus(request.requestId, 'declined');
              Navigator.pop(context);
            },
            child: const Text("Decline", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              await requestService.updateRequestStatus(request.requestId, 'accepted');
              Navigator.pop(context);
            },
            child: const Text("Accept Meeting"),
          ),
        ],

        // 3. APPROVE & SUPERVISE BUTTON (The Key)
        if (amISupervisor && request.status == 'accepted')
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
               // TODO: In the next step, we will update the Student's profile here!
               print("Simulating Approval for now...");
               Navigator.pop(context);
            },
            child: const Text("Approve & Supervise"),
          ),
      ],
    );
  }
}