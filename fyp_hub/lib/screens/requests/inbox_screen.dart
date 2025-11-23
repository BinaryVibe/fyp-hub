import 'package:flutter/material.dart';
import 'package:fyp_hub/models/request.dart';
import 'package:fyp_hub/shared/mock_data.dart';
import 'package:fyp_hub/screens/requests/request_details_dialog.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. TOGGLE THIS TO TEST DIFFERENT ROLES
    bool amISupervisor = false; // Try changing this to false!

    // 2. FILTER THE LIST
    final allRequests = MockData.myRequests;
    final myFilteredRequests = allRequests.where((req) {
      if (amISupervisor) {
        // Supervisors only see requests meant for them (type 'supervisor')
        return req.type == 'supervisor';
      } else {
        // Students only see requests meant for them (type 'teammate')
        return req.type == 'teammate';
      }
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(amISupervisor ? 'Supervisor Inbox' : 'Student Inbox'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: myFilteredRequests.length, // Use the filtered list
        itemBuilder: (context, index) {
          final req = myFilteredRequests[index]; // Use the filtered list
          
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
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                req.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: _buildStatusChip(req.status),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => RequestDetailsDialog(request: req),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.grey;
    if (status == 'pending') color = Colors.orange;
    if (status == 'accepted') color = Colors.green;
    
    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color.withOpacity(0.3),
    );
  }
}