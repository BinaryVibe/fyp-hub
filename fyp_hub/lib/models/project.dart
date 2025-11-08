// Represents an official, approved project.
class Project {
  final String projectId;
  final String title;
  final String description;
  final String supervisorId;
  final String supervisorName;
  final String teamLeadId;
  final List<Map<String, String>> teamMembers;

  // --- CONSTRUCTOR ---
  Project({
    required this.projectId,
    required this.title,
    required this.description,
    required this.supervisorId,
    required this.supervisorName,
    required this.teamLeadId,
    required this.teamMembers,
  });

  // --- JSON METHODS ---
  factory Project.fromJson(String id, Map<String, dynamic> json) {
    return Project(
      projectId: id,
      title: json['title'],
      description: json['description'],
      supervisorId: json['supervisorId'],
      supervisorName: json['supervisorName'],
      teamLeadId: json['teamLeadId'],
      teamMembers: List<Map<String, String>>.from(
        (json['teamMembers'] ?? []).map(
          (member) => Map<String, String>.from(member),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'supervisorId': supervisorId,
      'supervisorName': supervisorName,
      'teamLeadId': teamLeadId,
      'teamMembers': teamMembers,
    };
  }

  // --- OTHER METHODS ---
  @override
  String toString() {
    return 'Project: $title (Supervisor: $supervisorName)';
  }
}
