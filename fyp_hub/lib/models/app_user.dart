import 'package:cloud_firestore/cloud_firestore.dart';
import 'student.dart';
import 'supervisor.dart';

// This is an abstract "parent" class.
abstract class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role;

  // --- CONSTRUCTOR ---
  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
  });

  // --- JSON METHODS ---
  factory AppUser.fromJson(Map<String, dynamic> json) {
    switch (json['role']) {
      case 'student':
        return Student.fromJson(json);
      case 'supervisor':
        return Supervisor.fromJson(json);
      default:
        throw Exception('Unknown user role: ${json['role']}');
    }
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'name': name, 'role': role};
  }

  // --- OTHER METHODS ---
  @override
  String toString() {
    return '$name (Role: $role, UID: $uid)';
  }
}
