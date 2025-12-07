import 'package:flutter/material.dart';
import '../../services/marketplace_service.dart';
import '../../models/marketplace_post.dart';
import '../../models/supervisor.dart';
import 'create_post_screen.dart';
import '../../services/request_service.dart';
import '../../models/request.dart';
import '../../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarketplaceFeed extends StatelessWidget {
  const MarketplaceFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final MarketplaceService marketplaceService = MarketplaceService();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Marketplace'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ideas'),
              Tab(text: 'Teammates'),
              Tab(text: 'Supervisors'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- TAB 1: PROJECT IDEAS ---
            PostList(stream: marketplaceService.getProjectIdeas()),

            // --- TAB 2: FIND TEAMMATES ---
            PostList(stream: marketplaceService.getTeammatePosts()),

            // --- TAB 3: SUPERVISORS ---
            SupervisorList(stream: marketplaceService.getAllSupervisors()),
          ],
        ),
      ),
    );
  }
}

// --- REUSABLE WIDGET FOR POSTS (Tab 1 & 2) ---
class PostList extends StatelessWidget {
  final Stream<List<MarketplacePost>> stream;

  const PostList({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MarketplacePost>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No posts found. Be the first!",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final posts = snapshot.data!;
        return ListView.builder(
          itemCount: posts.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemBuilder: (context, index) {
            final post = posts[index];

            // Determine skills to show
            final skills = post.type == 'projectIdea'
                ? post.skillsNeeded
                : post.mySkills;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                // Specific Dark Grey Background
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[800]!), // Subtle border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.3,
                    ), // Real shadow, not green
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Title and Icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            post.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Ensure title is white
                            ),
                          ),
                        ),
                        // Small icon to indicate type
                        Icon(
                          post.type == 'projectIdea'
                              ? Icons.lightbulb_outline
                              : Icons.person_outline,
                          color: Colors.indigoAccent,
                          size: 20,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Author Name
                    Text(
                      "Posted by ${post.authorName}",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(
                      post.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Skills Chips (Fixed Visibility)
                    if (skills.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: skills
                            .map(
                              (skill) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  // Electric Blue Background
                                  color: Colors.indigoAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.indigoAccent.withOpacity(0.5),
                                  ),
                                ),
                                child: Text(
                                  skill,
                                  style: const TextStyle(
                                    color: Colors.white, // Explicit White Text
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
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

// --- WIDGET FOR SUPERVISORS (Tab 3) ---
class SupervisorList extends StatelessWidget {
  final Stream<List<Supervisor>> stream;

  const SupervisorList({super.key, required this.stream});

  void _showSupervisorDetails(BuildContext context, Supervisor supervisor) {
    final _messageController = TextEditingController();
    final _timeController = TextEditingController();

    // Initialize Services
    final AuthService _auth = AuthService();
    final RequestService _requestService = RequestService();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Required for full height
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.indigoAccent.withOpacity(0.2),
                      child: Text(
                        supervisor.name.isNotEmpty ? supervisor.name[0] : '?',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supervisor.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          supervisor.email,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // --- AVAILABILITY ---
                const Text(
                  "Availability",
                  style: TextStyle(
                    color: Colors.indigoAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  supervisor.availability.isNotEmpty
                      ? supervisor.availability
                      : "Not specified",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),

                // --- REQUEST FORM ---
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),
                const Text(
                  "Request a Meeting",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _timeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Proposed Time (e.g. Tuesday 2pm)',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _messageController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Short Message / Project Idea',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigoAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- SEND BUTTON ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigoAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final currentUser = _auth.currentUser;

                      if (currentUser != null) {
                        String fullMessage = _messageController.text;
                        if (_timeController.text.isNotEmpty) {
                          fullMessage +=
                              "\n\nProposed Time: ${_timeController.text}";
                        }

                        final newRequest = Request(
                          requestId: DateTime.now().millisecondsSinceEpoch
                              .toString(),
                          senderId: currentUser.uid,
                          senderName: currentUser.displayName ?? "Student",
                          receiverId: supervisor.uid,
                          type: 'supervisor',
                          status: 'pending',
                          message: fullMessage,
                          proposedTime: Timestamp.now(),
                        );

                        try {
                          await _requestService.sendRequest(newRequest);

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Request Sent Successfully!'),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You must be logged in'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Send Meeting Request",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
    return StreamBuilder<List<Supervisor>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No supervisors found.",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        final supervisors = snapshot.data!;
        return ListView.builder(
          itemCount: supervisors.length,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemBuilder: (context, index) {
            final supervisor = supervisors[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                // Matching the Dark Grey from PostList
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[800]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 25,
                  // Electric Blue Background (Low Opacity)
                  backgroundColor: Colors.indigoAccent.withOpacity(0.2),
                  child: Text(
                    supervisor.name.isNotEmpty
                        ? supervisor.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.indigoAccent, // Electric Blue Text
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                title: Text(
                  supervisor.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    supervisor.interests.isNotEmpty
                        ? supervisor.interests.join(", ")
                        : "No interests listed",
                    style: TextStyle(color: Colors.grey[400]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {
                  _showSupervisorDetails(context, supervisor);
                },
              ),
            );
          },
        );
      },
    );
  }
}
