// This class also extends AppUser.
import 'package:fyp_hub/models/app_user.dart';

class Supervisor extends AppUser {
  final List<String> interests;
  final String availability;

  // --- CONSTRUCTOR ---
  Supervisor({
    required super.uid,
    required super.email,
    required super.name,
    required this.interests,
    required this.availability,
  }) : super(role: 'supervisor'); // Role is hardcoded

  // --- JSON METHODS ---
  factory Supervisor.fromJson(Map<String, dynamic> json) {
    return Supervisor(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      interests: List<String>.from(json['interests'] ?? []),
      availability: json['availability'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({'interests': interests, 'availability': availability});
    return data;
  }

  // --- OTHER METHODS ---
  @override
  String toString() {
    return 'Supervisor: $name (Interests: ${interests.join(', ')})';
  }
}
