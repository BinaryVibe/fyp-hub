import 'package:cloud_firestore/cloud_firestore.dart';

class MarketplacePost {
  final String postId;
  final String authorId;
  final String authorName;
  final String type; // 'projectIdea' or 'findTeammate'
  final String title;
  final String description;
  final List<String> skillsNeeded;
  final List<String> mySkills;
  final Timestamp createdAt;

  // --- CONSTRUCTOR ---
  MarketplacePost({
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.type,
    required this.title,
    required this.description,
    required this.skillsNeeded,
    required this.mySkills,
    required this.createdAt,
  });

  // --- JSON METHODS ---
  factory MarketplacePost.fromJson(String id, Map<String, dynamic> json) {
    return MarketplacePost(
      postId: id,
      authorId: json['authorId'],
      authorName: json['authorName'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      skillsNeeded: List<String>.from(json['skillsNeeded'] ?? []),
      mySkills: List<String>.from(json['mySkills'] ?? []),
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'type': type,
      'title': title,
      'description': description,
      'skillsNeeded': skillsNeeded,
      'mySkills': mySkills,
      'createdAt': createdAt,
    };
  }

  // --- OTHER METHODS ---
  @override
  String toString() {
    return 'Post: $title (Type: $type, by $authorName)';
  }
}
