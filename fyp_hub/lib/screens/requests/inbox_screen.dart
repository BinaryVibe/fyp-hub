// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // To get our ID
// import 'package:fyp_hub/models/request.dart';
// import 'package:fyp_hub/services/request_service.dart'; // Your new service
// import 'package:fyp_hub/screens/requests/request_details_dialog.dart';

// class InboxScreen extends StatelessWidget {
//   const InboxScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 1. Get the current user
//     final user = FirebaseAuth.instance.currentUser;

//     // Safety check: This shouldn't happen if wrapped correctly, but good practice
//     if (user == null) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(child: Text("Error: Not logged in", style: TextStyle(color: Colors.white))),
//       );
//     }

//     final requestService = RequestService();

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text('Inbox'),
//         backgroundColor: Colors.black,
//       ),
//       // 2. STREAM BUILDER: Listens to the database!
//       body: StreamBuilder<List<Request>>(
//         stream: requestService.getMyInboxStream(user.uid),
//         builder: (context, snapshot) {
//           // A. Handle Loading State
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // B. Handle Error State
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
//           }

//           // C. Handle Empty State
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // A nice large icon
//                   Icon(Icons.mark_email_read_outlined, size: 100, color: Colors.grey[800]),
//                   const SizedBox(height: 20),
//                   // A clear title
//                   const Text(
//                     "All Caught Up!",
//                     style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
//                   ),
//                   const SizedBox(height: 10),
//                   // A helpful subtitle
//                   const Text(
//                     "You have no pending requests right now.\nCheck back later!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             );
//           }

//           // D. Handle Data (The List)
//           final requests = snapshot.data!;

//           return ListView.builder(
//             itemCount: requests.length,
//             itemBuilder: (context, index) {
//               final req = requests[index];
//               final isTeammate = req.type == 'teammate';

//               return Card(
//                 color: Colors.grey[900],
//                 margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
//                 child: ListTile(
//                   leading: CircleAvatar(
//                     backgroundColor: isTeammate ? Colors.blue : Colors.purple,
//                     child: Icon(
//                       isTeammate ? Icons.person : Icons.school,
//                       color: Colors.white,
//                     ),
//                   ),
//                   title: Text(
//                     req.senderName,
//                     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     req.message,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                   trailing: _buildStatusChip(req.status),
//                   onTap: () {
//                     // Open the details dialog
//                     showDialog(
//                       context: context,
//                       builder: (context) => RequestDetailsDialog(request: req),
//                     );
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatusChip(String status) {
//     Color color = Colors.grey;
//     if (status == 'pending') color = Colors.orange;
//     if (status == 'accepted') color = Colors.green;
//     if (status == 'declined') color = Colors.red;

//     return Chip(
//       label: Text(
//         status.toUpperCase(),
//         style: const TextStyle(fontSize: 10, color: Colors.white),
//       ),
//       backgroundColor: color.withOpacity(0.3),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // To get our ID
import 'package:fyp_hub/models/request.dart';
import 'package:fyp_hub/services/request_service.dart'; // Your new service
import 'package:fyp_hub/screens/requests/request_details_dialog.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- THEME COLORS ---
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary; // Night Charcoal
    final secondaryColor = theme.colorScheme.secondary; // Ice Blue
    final scaffoldColor = theme.scaffoldBackgroundColor; // Snow White
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    // 1. Get the current user
    final user = FirebaseAuth.instance.currentUser;

    // Safety check
    if (user == null) {
      return Scaffold(
        backgroundColor: scaffoldColor,
        body: Center(
          child: Text(
            "Error: Not logged in",
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      );
    }

    final requestService = RequestService();

    return Scaffold(
      backgroundColor: scaffoldColor, // UI Change: Snow White
      appBar: AppBar(
        title: Text(
          'Inbox',
          style: TextStyle(
            color: primaryColor, // UI Change: Dark text
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Cleaner look
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor), // Dark back arrow
      ),
      // 2. STREAM BUILDER: Listens to the database!
      body: StreamBuilder<List<Request>>(
        stream: requestService.getMyInboxStream(user.uid),
        builder: (context, snapshot) {
          // A. Handle Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: secondaryColor),
            );
          }

          // B. Handle Error State
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }

          // C. Handle Empty State
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // A nice large icon
                  Icon(
                    Icons.mark_email_read_outlined,
                    size: 100,
                    color: subtitleColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  // A clear title
                  Text(
                    "All Caught Up!",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // A helpful subtitle
                  Text(
                    "You have no pending requests right now.\nCheck back later!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: subtitleColor),
                  ),
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

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  // UI Change: White Card
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: subtitleColor.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    // UI Change: Use theme colors or standard colors with lower opacity
                    backgroundColor: isTeammate
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.purple.withOpacity(0.1),
                    child: Icon(
                      isTeammate ? Icons.person : Icons.school,
                      color: isTeammate ? Colors.blue : Colors.purple,
                    ),
                  ),
                  title: Text(
                    req.senderName,
                    style: TextStyle(
                      color: primaryColor, // Dark text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    req.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: subtitleColor),
                  ),
                  trailing: _buildStatusChip(req.status, primaryColor),
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

  Widget _buildStatusChip(String status, Color primaryColor) {
    Color color = Colors.grey;
    if (status == 'pending') color = Colors.orange;
    if (status == 'accepted') color = Colors.green;
    if (status == 'declined') color = Colors.red;

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          color: status == 'pending'
              ? Colors.white
              : Colors.white, // White text for contrast
          fontWeight: FontWeight.bold,
        ),
      ),
      // UI Change: Solid color for status chips
      backgroundColor: color,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
