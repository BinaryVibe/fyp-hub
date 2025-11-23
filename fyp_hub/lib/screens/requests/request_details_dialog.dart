import 'package:flutter/material.dart';
import 'package:fyp_hub/models/request.dart';

class RequestDetailsDialog extends StatelessWidget {
  final Request request;
  const RequestDetailsDialog({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    // MOCK: Assume we are a supervisor for testing purposes
    bool amISupervisor = true; // Change to true to test supervisor view

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
          
          // --- THE GATE LOGIC ---
          // Show this ONLY if: I am Supervisor + It is a Supervisor Request + It is Accepted
          if (amISupervisor && request.type == 'supervisor' && request.status == 'accepted')
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
        
        // The "Approve & Supervise" Button
        if (amISupervisor && request.type == 'supervisor' && request.status == 'accepted')
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
               // TODO: Later, this will update Firebase to "unlock" the student's project
               print("PROJECT UNLOCKED!");
               Navigator.pop(context);
            },
            child: const Text("Approve & Supervise"),
          ),
      ],
    );
  }
}