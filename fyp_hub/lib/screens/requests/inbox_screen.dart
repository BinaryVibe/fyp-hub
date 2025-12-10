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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_hub/models/request.dart';
import 'package:fyp_hub/services/request_service.dart';
import 'package:fyp_hub/screens/requests/request_details_dialog.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final scaffoldColor = theme.scaffoldBackgroundColor;

    final user = FirebaseAuth.instance.currentUser;
    final requestService = RequestService();

    if (user == null) {
      return Scaffold(body: Center(child: Text("Error: Not logged in")));
    }

    // 1. USE DEFAULT TAB CONTROLLER FOR 2 TABS
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          title: Text(
            'Requests',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryColor),
          // 2. ADD THE TAB BAR
          bottom: TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            tabs: const [
              Tab(text: "Inbox"), // Requests received
              Tab(text: "Sent"), // Requests sent (Status tracking)
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- TAB 1: RECEIVED (INBOX) ---
            _RequestList(
              stream: requestService.getMyInboxStream(user.uid),
              isSentTab: false, // Can act on these
            ),

            // --- TAB 2: SENT (STATUS TRACKING) ---
            _RequestList(
              stream: requestService.getMySentRequestsStream(user.uid),
              isSentTab: true, // Read-only
            ),
          ],
        ),
      ),
    );
  }
}

// --- REUSABLE LIST WIDGET ---
class _RequestList extends StatelessWidget {
  final Stream<List<Request>> stream;
  final bool isSentTab;

  const _RequestList({required this.stream, required this.isSentTab});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;
    final secondaryColor = theme.colorScheme.secondary;

    return StreamBuilder<List<Request>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: secondaryColor),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSentTab
                      ? Icons.send_outlined
                      : Icons.mark_email_read_outlined,
                  size: 80,
                  color: Colors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 10),
                Text(
                  isSentTab ? "No sent requests" : "Inbox Empty",
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ],
            ),
          );
        }

        final requests = snapshot.data!;

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            final isTeammate = req.type == 'teammate';

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
                  backgroundColor: isTeammate
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.purple.withOpacity(0.1),
                  child: Icon(
                    // Icon logic: If sent tab, show 'upload' arrow, else 'person'
                    isSentTab
                        ? Icons.arrow_outward
                        : (isTeammate ? Icons.person : Icons.school),
                    color: isTeammate ? Colors.blue : Colors.purple,
                  ),
                ),
                title: Text(
                  // If I sent it, show "To: Receiver" (Ideally we'd fetch name, but for now we emphasize status)
                  // If I received it, show "From: SenderName"
                  isSentTab ? "Request Sent" : req.senderName,
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  req.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: subtitleColor),
                ),
                trailing: _buildStatusChip(req.status),
                onTap: () {
                  // SAFETY CHECK:
                  // Only allow opening dialog if it's the INBOX (Received) tab.
                  // Students should NOT be able to open/edit their own sent requests.
                  if (!isSentTab) {
                    showDialog(
                      context: context,
                      builder: (context) => RequestDetailsDialog(request: req),
                    );
                  } else {
                    // Optional: Show simple details snackbar or read-only popup
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Status: ${req.status.toUpperCase()}"),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
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
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
