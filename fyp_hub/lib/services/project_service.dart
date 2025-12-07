import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_hub/models/project.dart';
import 'package:fyp_hub/models/milestone.dart';

class ProjectService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. CREATE PROJECT (Updated)
  Future<void> createProject(Project project) async {
    try {
      // We convert the object to data...
      final data = project.toJson();
      
      // ...AND we add a special "Search List" so we can find this project easily later
      data['memberIds'] = [project.teamLeadId]; 

      await _db.collection('projects').doc(project.projectId).set(data);
    } catch (e) {
      print("Error creating project: $e");
      rethrow;
    }
  }

  // 2. GET MY PROJECTS (Updated Query)
  Stream<List<Project>> getMyProjectsStream(String myUid) {
    return _db
        .collection('projects')
        // CHANGED: Now we look if your ID is anywhere in the member list!
        .where('memberIds', arrayContains: myUid) 
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Project.fromJson(doc.id, doc.data()))
            .toList());
  }
  
  // 3. GET SUPERVISOR PROJECTS
  Stream<List<Project>> getSupervisorProjectsStream(String myUid) {
    return _db
        .collection('projects')
        .where('supervisorId', isEqualTo: myUid)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Project.fromJson(doc.id, doc.data()))
            .toList());
  }

  // 4. ADD MILESTONE
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

  // 5. UPDATE MILESTONE
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

  // 6. STREAM MILESTONES
  Stream<List<Milestone>> getMilestonesStream(String projectId) {
    return _db
        .collection('projects')
        .doc(projectId)
        .collection('milestones')
        .orderBy('deadline')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Milestone.fromJson(doc.id, doc.data());
      }).toList();
    });
  }

  // 7. ADD TEAMMATE (Updated)
  Future<void> addTeammate(String projectId, String newMemberId, String newMemberName) async {
    try {
      await _db.collection('projects').doc(projectId).update({
        // Add to the display list (Name + UID)
        'teamMembers': FieldValue.arrayUnion([
          {'uid': newMemberId, 'name': newMemberName}
        ]),
        // Add to the search list (UID only) - This enables the Dashboard!
        'memberIds': FieldValue.arrayUnion([newMemberId]) 
      });
    } catch (e) {
      print("Error adding teammate: $e");
      rethrow;
    }
  }
}