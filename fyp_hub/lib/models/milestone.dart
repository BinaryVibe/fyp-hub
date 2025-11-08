import 'package:cloud_firestore/cloud_firestore.dart';

class Milestone {
  final String milestoneId;
  final String title;
  final Timestamp deadline;
  final String status; // 'Pending', 'Submitted', 'Approved'

  // --- CONSTRUCTOR ---
  Milestone({
    required this.milestoneId,
    required this.title,
    required this.deadline,
    required this.status,
  });

  // --- JSON METHODS ---
  factory Milestone.fromJson(String id, Map<String, dynamic> json) {
    return Milestone(
      milestoneId: id,
      title: json['title'],
      deadline: json['deadline'] ?? Timestamp.now(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'deadline': deadline, 'status': status};
  }

  // --- OTHER METHODS ---
  @override
  String toString() {
    return '$title (Status: $status)';
  }
}
