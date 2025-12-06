import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // To get our ID
import 'package:fyp_hub/models/request.dart';
import 'package:fyp_hub/services/request_service.dart'; // Your new service
import 'package:fyp_hub/screens/requests/request_details_dialog.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get the current user
    final user = FirebaseAuth.instance.currentUser;
    
    // Safety check: This shouldn't happen if wrapped correctly, but good practice
    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: Text("Error: Not logged in", style: TextStyle(color: Colors.white))),
      );
    }

    final requestService = RequestService();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: Colors.black,
      ),
      // 2. STREAM BUILDER: Listens to the database!
      body: StreamBuilder<List<Request>>(
        stream: requestService.getMyInboxStream(user.uid),
        builder: (context, snapshot) {
          // A. Handle Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // B. Handle Error State
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }

          // C. Handle Empty State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No new requests", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // D. Handle Data (The List)
          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              final isTeammate = req.type == 'teammate';
              
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isTeammate ? Colors.blue : Colors.purple,
                    child: Icon(
                      isTeammate ? Icons.person : Icons.school,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    req.senderName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    req.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: _buildStatusChip(req.status),
                  onTap: () {
                    // Open the details dialog
                    showDialog(
                      context: context,
                      builder: (context) => RequestDetailsDialog(request: req),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.grey;
    if (status == 'pending') color = Colors.orange;
    if (status == 'accepted') color = Colors.green;
    if (status == 'declined') color = Colors.red;
    
    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color.withOpacity(0.3),
    );
  }
}