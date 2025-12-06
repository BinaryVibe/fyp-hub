import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_hub/models/project.dart';
import 'package:fyp_hub/models/milestone.dart';

class ProjectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. CREATE PROJECT (Student)
  Future<void> createProject(Project project) async {
    try {
      // Use the project's ID as the document ID
      await _db.collection('projects').doc(project.projectId).set(project.toJson());
    } catch (e) {
      print("Error creating project: $e");
      rethrow;
    }
  }

  // 2. GET MY PROJECT (Student or Supervisor)
  // This looks for a project where I am either the Lead OR the Supervisor
  Stream<List<Project>> getMyProjectsStream(String myUid) {
    // Note: Firestore OR queries are tricky. 
    // For simplicity, we will query where 'teamLeadId' == me. 
    // Supervisors might need a separate query or a better data structure later.
    return _db
        .collection('projects')
        .where('teamLeadId', isEqualTo: myUid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Project.fromJson(doc.id, doc.data()))
            .toList());
  }
  
  // Supervisor View (Alternative Stream)
  Stream<List<Project>> getSupervisorProjectsStream(String myUid) {
    return _db
        .collection('projects')
        .where('supervisorId', isEqualTo: myUid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Project.fromJson(doc.id, doc.data()))
            .toList());
  }

  // 3. ADD MILESTONE (Supervisor)
  Future<void> addMilestone(String projectId, Milestone milestone) async {
    try {
      await _db
          .collection('projects')
          .doc(projectId)
          .collection('milestones')
          .doc(milestone.milestoneId)
          .set(milestone.toJson());
    } catch (e) {
      print("Error adding milestone: $e");
      rethrow;
    }
  }

  // 4. UPDATE MILESTONE (Approve/Edit)
  Future<void> updateMilestone(String projectId, Milestone milestone) async {
    try {
      await _db
          .collection('projects')
          .doc(projectId)
          .collection('milestones')
          .doc(milestone.milestoneId)
          .update(milestone.toJson());
    } catch (e) {
      print("Error updating milestone: $e");
      rethrow;
    }
  }

  // 5. STREAM MILESTONES (Real-time List)
  Stream<List<Milestone>> getMilestonesStream(String projectId) {
    return _db
        .collection('projects')
        .doc(projectId)
        .collection('milestones')
        .orderBy('deadline') // Sort by date
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Milestone.fromJson(doc.id, doc.data());
      }).toList();
    });
  }
}