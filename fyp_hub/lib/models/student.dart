// This class extends AppUser.
import 'package:fyp_hub/models/app_user.dart';

class Student extends AppUser {
  final List<String> skills;
  final String domain;
  final String? supervisorId;
  final String? supervisorName;
  final List<String> teammates;

  // --- CONSTRUCTOR ---
  Student({
    required super.uid,
    required super.email,
    required super.name,
    required this.skills,
    required this.domain,
    this.supervisorId,
    this.supervisorName,
    required this.teammates,
  }) : super(role: 'student'); // Role is hardcoded

  // --- JSON METHODS ---
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      skills: List<String>.from(json['skills'] ?? []),
      domain: json['domain'] ?? '',
      supervisorId: json['supervisorId'],
      supervisorName: json['supervisorName'],
      teammates: List<String>.from(json['teammates'] ?? []),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'skills': skills,
      'domain': domain,
      'supervisorId': supervisorId,
      'supervisorName': supervisorName,
      'teammates': teammates,
    });
    return data;
  }

  // --- OTHER METHODS ---
  @override
  String toString() {
    return 'Student: $name (Skills: ${skills.join(', ')})';
  }
}
