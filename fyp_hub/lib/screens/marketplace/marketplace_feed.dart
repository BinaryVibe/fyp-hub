// import 'package:flutter/material.dart';
// import '../../services/marketplace_service.dart';
// import '../../models/marketplace_post.dart';
// import '../../models/supervisor.dart';
// import '../../services/request_service.dart';
// import '../../models/request.dart';
// import '../../services/auth_service.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MarketplaceFeed extends StatelessWidget {
//   const MarketplaceFeed({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final MarketplaceService marketplaceService = MarketplaceService();

//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Marketplace'),
//           automaticallyImplyLeading: false,
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Ideas'),
//               Tab(text: 'Teammates'),
//               Tab(text: 'Supervisors'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // --- TAB 1: PROJECT IDEAS ---
//             PostList(stream: marketplaceService.getProjectIdeas()),

//             // --- TAB 2: FIND TEAMMATES ---
//             PostList(stream: marketplaceService.getTeammatePosts()),

//             // --- TAB 3: SUPERVISORS ---
//             SupervisorList(stream: marketplaceService.getAllSupervisors()),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // --- REUSABLE WIDGET FOR POSTS (Tab 1 & 2) ---
// class PostList extends StatelessWidget {
//   final Stream<List<MarketplacePost>> stream;

//   const PostList({super.key, required this.stream});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<MarketplacePost>>(
//       stream: stream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(
//             child: Text(
//               "No posts found. Be the first!",
//               style: TextStyle(color: Colors.grey),
//             ),
//           );
//         }

//         final posts = snapshot.data!;
//         return ListView.builder(
//           itemCount: posts.length,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           itemBuilder: (context, index) {
//             final post = posts[index];

//             // Determine skills to show
//             final skills = post.type == 'projectIdea'
//                 ? post.skillsNeeded
//                 : post.mySkills;

//             return Container(
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 // Specific Dark Grey Background
//                 color: const Color(0xFF1E1E1E),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey[800]!), // Subtle border
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(
//                       0.3,
//                     ), // Real shadow, not green
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Header: Title and Icon
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             post.title,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white, // Ensure title is white
//                             ),
//                           ),
//                         ),
//                         // Small icon to indicate type
//                         Icon(
//                           post.type == 'projectIdea'
//                               ? Icons.lightbulb_outline
//                               : Icons.person_outline,
//                           color: Colors.indigoAccent,
//                           size: 20,
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     // Author Name
//                     Text(
//                       "Posted by ${post.authorName}",
//                       style: TextStyle(
//                         color: Colors.grey[400],
//                         fontSize: 13,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     // Description
//                     Text(
//                       post.description,
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.grey[300],
//                         fontSize: 14,
//                         height: 1.4,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Skills Chips (Fixed Visibility)
//                     if (skills.isNotEmpty) ...[
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: skills
//                             .map(
//                               (skill) => Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 6,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   // Electric Blue Background
//                                   color: Colors.indigoAccent.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(20),
//                                   border: Border.all(
//                                     color: Colors.indigoAccent.withOpacity(0.5),
//                                   ),
//                                 ),
//                                 child: Text(
//                                   skill,
//                                   style: const TextStyle(
//                                     color: Colors.white, // Explicit White Text
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// // --- WIDGET FOR SUPERVISORS (Tab 3) ---
// class SupervisorList extends StatelessWidget {
//   final Stream<List<Supervisor>> stream;

//   const SupervisorList({super.key, required this.stream});

//   void _showSupervisorDetails(BuildContext context, Supervisor supervisor) {
//     final _messageController = TextEditingController();
//     final _timeController = TextEditingController();

//     // Initialize Services
//     final AuthService _auth = AuthService();
//     final RequestService _requestService = RequestService();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // Required for full height
//       backgroundColor: const Color(0xFF1E1E1E),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- HEADER ---
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[600],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.indigoAccent.withOpacity(0.2),
//                       child: Text(
//                         supervisor.name.isNotEmpty ? supervisor.name[0] : '?',
//                         style: const TextStyle(
//                           fontSize: 24,
//                           color: Colors.indigoAccent,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           supervisor.name,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Text(
//                           supervisor.email,
//                           style: TextStyle(color: Colors.grey[400]),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),

//                 // --- AVAILABILITY ---
//                 const Text(
//                   "Availability",
//                   style: TextStyle(
//                     color: Colors.indigoAccent,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 Text(
//                   supervisor.availability.isNotEmpty
//                       ? supervisor.availability
//                       : "Not specified",
//                   style: const TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(height: 20),

//                 // --- REQUEST FORM ---
//                 const Divider(color: Colors.grey),
//                 const SizedBox(height: 10),
//                 const Text(
//                   "Request a Meeting",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 TextField(
//                   controller: _timeController,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     labelText: 'Proposed Time (e.g. Tuesday 2pm)',
//                     labelStyle: TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.indigoAccent),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 10),

//                 TextField(
//                   controller: _messageController,
//                   maxLines: 3,
//                   style: const TextStyle(color: Colors.white),
//                   decoration: const InputDecoration(
//                     labelText: 'Short Message / Project Idea',
//                     labelStyle: TextStyle(color: Colors.grey),
//                     border: OutlineInputBorder(),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.indigoAccent),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // --- SEND BUTTON ---
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.indigoAccent,
//                       foregroundColor: Colors.white,
//                     ),
//                     onPressed: () async {
//                       final currentUser = _auth.currentUser;

//                       if (currentUser != null) {
//                         String fullMessage = _messageController.text;
//                         if (_timeController.text.isNotEmpty) {
//                           fullMessage +=
//                               "\n\nProposed Time: ${_timeController.text}";
//                         }

//                         final newRequest = Request(
//                           requestId: DateTime.now().millisecondsSinceEpoch
//                               .toString(),
//                           senderId: currentUser.uid,
//                           senderName: currentUser.displayName ?? "Student",
//                           receiverId: supervisor.uid,
//                           type: 'supervisor',
//                           status: 'pending',
//                           message: fullMessage,
//                           proposedTime: Timestamp.now(),
//                         );

//                         try {
//                           await _requestService.sendRequest(newRequest);

//                           if (context.mounted) {
//                             Navigator.pop(context);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Request Sent Successfully!'),
//                               ),
//                             );
//                           }
//                         } catch (e) {
//                           if (context.mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Error: $e')),
//                             );
//                           }
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('You must be logged in'),
//                           ),
//                         );
//                       }
//                     },
//                     child: const Text(
//                       "Send Meeting Request",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Supervisor>>(
//       stream: stream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(
//             child: Text(
//               "No supervisors found.",
//               style: TextStyle(color: Colors.grey),
//             ),
//           );
//         }

//         final supervisors = snapshot.data!;
//         return ListView.builder(
//           itemCount: supervisors.length,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           itemBuilder: (context, index) {
//             final supervisor = supervisors[index];
//             return Container(
//               margin: const EdgeInsets.only(bottom: 12),
//               decoration: BoxDecoration(
//                 // Matching the Dark Grey from PostList
//                 color: const Color(0xFF1E1E1E),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.grey[800]!),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.3),
//                     blurRadius: 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ListTile(
//                 contentPadding: const EdgeInsets.all(16),
//                 leading: CircleAvatar(
//                   radius: 25,
//                   // Electric Blue Background (Low Opacity)
//                   backgroundColor: Colors.indigoAccent.withOpacity(0.2),
//                   child: Text(
//                     supervisor.name.isNotEmpty
//                         ? supervisor.name[0].toUpperCase()
//                         : '?',
//                     style: const TextStyle(
//                       color: Colors.indigoAccent, // Electric Blue Text
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//                 title: Text(
//                   supervisor.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 subtitle: Padding(
//                   padding: const EdgeInsets.only(top: 6.0),
//                   child: Text(
//                     supervisor.interests.isNotEmpty
//                         ? supervisor.interests.join(", ")
//                         : "No interests listed",
//                     style: TextStyle(color: Colors.grey[400]),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 trailing: const Icon(Icons.chevron_right, color: Colors.grey),
//                 onTap: () {
//                   _showSupervisorDetails(context, supervisor);
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/marketplace_service.dart';
import '../../models/marketplace_post.dart';
import '../../models/supervisor.dart';
import '../../models/student.dart'; 
import '../../models/app_user.dart'; 
import '../../services/request_service.dart';
import '../../models/request.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart'; 
import '../../services/project_service.dart';

class MarketplaceFeed extends StatelessWidget {
  const MarketplaceFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketplaceService marketplaceService = MarketplaceService();
    final theme = Theme.of(context);
    final secondaryColor = theme.colorScheme.secondary;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Marketplace'),
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: secondaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: secondaryColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Ideas'),
              Tab(text: 'Teammates'),
              Tab(text: 'Supervisors'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PostList(stream: marketplaceService.getProjectIdeas()),
            PostList(stream: marketplaceService.getTeammatePosts()),
            SupervisorList(stream: marketplaceService.getAllSupervisors()),
          ],
        ),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  final Stream<List<MarketplacePost>> stream;

  const PostList({super.key, required this.stream});

  void _showProfilePopup(BuildContext context, String authorId, String authorName) async {
    final userService = UserService();
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary; 
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = await userService.getUserProfile(authorId);
      
      if (context.mounted) {
        Navigator.pop(context); 
        
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User profile not found.")));
          return;
        }

        showDialog(
          context: context,
          builder: (ctx) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: primaryColor,
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      if (user is Student) ...[
                        _buildBeautifulInfoRow(Icons.category_rounded, "Domain", user.domain),
                        const SizedBox(height: 20),
                        _buildBeautifulInfoRow(Icons.code_rounded, "Skills", user.skills.join(", ")),
                      ] else if (user is Supervisor) ...[
                        _buildBeautifulInfoRow(Icons.access_time_filled_rounded, "Availability", user.availability),
                        const SizedBox(height: 20),
                        _buildBeautifulInfoRow(Icons.interests_rounded, "Interests", user.interests.join(", ")),
                      ],
                      const SizedBox(height: 20),
                      _buildBeautifulInfoRow(Icons.email_rounded, "Email", user.email),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("CLOSE"),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Widget _buildBeautifulInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blueGrey, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? "Not specified" : value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendJoinRequest(BuildContext context, MarketplacePost post) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You must be logged in.")));
      return;
    }

    if (user.uid == post.authorId) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You can't request to join your own post!")));
      return;
    }

    final userService = UserService();
    final projectService = ProjectService();

    // --- 🛑 CHECK 1: IS USER A SUPERVISOR? ---
    try {
      final userProfile = await userService.getUserProfile(user.uid);
      if (userProfile is Supervisor) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🚫 Supervisors cannot join student projects."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
    // ----------------------------------------

    // --- 🛑 CHECK 2: ALREADY IN PROJECT? ---
    final myProjects = await projectService.getMyProjectsStream(user.uid).first;
    if (myProjects.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ You are already part of a project!"), backgroundColor: Colors.red),
      );
      return;
    }
    // ---------------------------------------

    final requestService = RequestService();
    final TextEditingController msgController = TextEditingController();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Request to Join", style: TextStyle(color: Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Send a message to the team lead:", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            TextField(
              controller: msgController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(hintText: "Hi, I'd like to join...", border: OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              try {
                final myDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                final myName = myDoc.data()?['name'] ?? "Unknown Student";

                final newReq = Request(
                  requestId: DateTime.now().millisecondsSinceEpoch.toString(),
                  senderId: user.uid,
                  senderName: myName,
                  receiverId: post.authorId,
                  receiverName: post.authorName,
                  type: 'teammate',
                  status: 'pending',
                  message: msgController.text.trim().isEmpty 
                      ? "I am interested in your project: ${post.title}" 
                      : msgController.text.trim(),
                  proposedTime: Timestamp.now(),
                );

                await requestService.sendRequest(newReq);
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Request Sent Successfully! 🚀")));
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Send Request"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary; 
    final secondaryColor = theme.colorScheme.secondary; 
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return StreamBuilder<List<MarketplacePost>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: secondaryColor));
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No posts found.", style: TextStyle(color: subtitleColor)));
        }

        final posts = snapshot.data!;
        return ListView.builder(
          itemCount: posts.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemBuilder: (context, index) {
            final post = posts[index];
            final skills = post.type == 'projectIdea' ? post.skillsNeeded : post.mySkills;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: subtitleColor.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PROFILE AVATAR BUTTON
                        GestureDetector(
                          onTap: () => _showProfilePopup(context, post.authorId, post.authorName),
                          child: CircleAvatar(
                            backgroundColor: primaryColor,
                            radius: 20,
                            child: Text(
                              post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Posted by ${post.authorName}",
                                style: TextStyle(color: subtitleColor, fontSize: 13, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send_rounded),
                          color: Colors.blue,
                          tooltip: "Request to Join",
                          onPressed: () => _sendJoinRequest(context, post),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      post.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: primaryColor.withOpacity(0.8), fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    if (skills.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skills.map((skill) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: secondaryColor.withOpacity(0.5)),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        )).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class SupervisorList extends StatelessWidget {
  final Stream<List<Supervisor>> stream;
  const SupervisorList({super.key, required this.stream});

  void _showSupervisorDetails(BuildContext context, Supervisor supervisor) {
    final _messageController = TextEditingController();
    final _timeController = TextEditingController();
    final AuthService _auth = AuthService();
    final RequestService _requestService = RequestService();
    final UserService _userService = UserService(); // Use service for role check
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: primaryColor,
                      child: Text(supervisor.name.isNotEmpty ? supervisor.name[0] : '?', style: TextStyle(fontSize: 24, color: secondaryColor, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(supervisor.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                        Text(supervisor.email, style: TextStyle(color: subtitleColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("Availability", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(supervisor.availability.isNotEmpty ? supervisor.availability : "Not specified"),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                TextField(controller: _timeController, decoration: const InputDecoration(labelText: 'Proposed Time', border: OutlineInputBorder())),
                const SizedBox(height: 10),
                TextField(controller: _messageController, maxLines: 3, decoration: const InputDecoration(labelText: 'Message', border: OutlineInputBorder())),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: secondaryColor),
                    onPressed: () async {
                      final currentUser = _auth.currentUser;
                      if (currentUser != null) {
                        
                        // --- 🛑 CHECK 1: IS USER A SUPERVISOR? ---
                        final userProfile = await _userService.getUserProfile(currentUser.uid);
                        if (userProfile is Supervisor) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("🚫 Supervisors cannot request other supervisors."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          return;
                        }
                        // ----------------------------------------

                        // --- 🛑 CHECK 2: ALREADY IN PROJECT? ---
                        final projectService = ProjectService();
                        final myProjects = await projectService.getMyProjectsStream(currentUser.uid).first;

                        if (myProjects.isNotEmpty) {
                          if (context.mounted) {
                            Navigator.pop(context); 
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("⚠️ You are already in a project! You cannot request a supervisor."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                          return;
                        }
                        // ------------------------------------------

                        try {
                          final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
                          final String realName = userDoc.data()?['name'] ?? "Student";
                          String fullMessage = _messageController.text;
                          if (_timeController.text.isNotEmpty) fullMessage += "\n\nProposed Time: ${_timeController.text}";

                          final newRequest = Request(
                            requestId: DateTime.now().millisecondsSinceEpoch.toString(),
                            senderId: currentUser.uid,
                            senderName: realName,
                            receiverId: supervisor.uid,
                            receiverName: supervisor.name,
                            type: 'supervisor',
                            status: 'pending',
                            message: fullMessage,
                            proposedTime: Timestamp.now(),
                          );
                          await _requestService.sendRequest(newRequest);
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Meeting Request Sent! 🎓")));
                          }
                        } catch (e) { print(e); }
                      }
                    },
                    child: const Text("Send Meeting Request"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return StreamBuilder<List<Supervisor>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(color: secondaryColor));
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No supervisors found."));
        final supervisors = snapshot.data!;
        return ListView.builder(
          itemCount: supervisors.length,
          itemBuilder: (context, index) {
            final supervisor = supervisors[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: subtitleColor.withOpacity(0.2))),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: primaryColor, child: Text(supervisor.name.isNotEmpty ? supervisor.name[0] : '?', style: TextStyle(color: secondaryColor))),
                title: Text(supervisor.name, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                subtitle: Text(supervisor.interests.join(", "), maxLines: 1),
                onTap: () => _showSupervisorDetails(context, supervisor),
              ),
            );
          },
        );
      },
    );
  }
}