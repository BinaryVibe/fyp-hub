import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../services/marketplace_service.dart';
import '../../models/marketplace_post.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _skillController = TextEditingController();

  // "projectIdea" is default
  String _postType = 'projectIdea';
  final List<String> _skills = [];
  bool _isLoading = false;

  final AuthService _auth = AuthService();
  final MarketplaceService _marketplaceService = MarketplaceService();

  // --- LOGIC: Add a skill tag ---
  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
        _skillController.clear();
      });
    }
  }

  // --- LOGIC: Submit the Post ---
  Future<void> _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    if (_skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one skill/tag')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Get Current User Info form Auth
      final authUser = _auth.currentUser;
      if (authUser == null) throw Exception("User not logged in");

      // 2. FETCH REAL NAME FROM DATABASE (The "Perfect Logic" Fix)
      // We don't trust authUser.displayName because it might be null.
      // We go directly to the 'users' collection to get the profile name.
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User profile not found in database.");
      }

      final String authorName = userDoc.data()?['name'] ?? 'Unknown Student';

      // 3. Create the Post Object
      final newPost = MarketplacePost(
        postId: DateTime.now().millisecondsSinceEpoch
            .toString(), // Simple unique ID
        authorId: authUser.uid,
        authorName: authorName, // <--- Now using the real name from Firestore
        type: _postType,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        skillsNeeded: _postType == 'projectIdea' ? _skills : [],
        mySkills: _postType == 'findTeammate' ? _skills : [],
        createdAt: Timestamp.now(),
      );

      // 4. Save to Firestore
      await _marketplaceService.createPost(newPost);

      // 5. Success & Close
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post Created Successfully!')),
        );
        Navigator.pop(context); // Go back to feed
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- 1. Post Type Selector ---
              Text(
                "What are you posting?",
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 10),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'projectIdea',
                    label: Text('Project Idea'),
                    icon: Icon(Icons.lightbulb_outline),
                  ),
                  ButtonSegment(
                    value: 'findTeammate',
                    label: Text('Find Team'),
                    icon: Icon(Icons.group_add),
                  ),
                ],
                selected: {_postType},
                onSelectionChanged: (newSelection) {
                  setState(() => _postType = newSelection.first);
                },
                style: ButtonStyle(
                  // FIX: Replaced MaterialStateProperty with WidgetStateProperty
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) => states.contains(WidgetState.selected)
                        ? primaryColor
                        : null,
                  ),
                  foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) => states.contains(WidgetState.selected)
                        ? Colors.white
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- 2. Title & Description ---
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter this field';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- 3. Skills Input ---
              Text(
                _postType == 'projectIdea' ? "Skills Needed" : "My Skills",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _skillController,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Flutter, Python',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => _addSkill(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    onPressed: _addSkill,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // --- 4. Skills Display (Chips) ---
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _skills.map((skill) {
                  return Chip(
                    label: Text(skill),
                    backgroundColor: primaryColor.withOpacity(0.2),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() => _skills.remove(skill));
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // --- 5. Submit Button ---
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPost,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'POST NOW',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
