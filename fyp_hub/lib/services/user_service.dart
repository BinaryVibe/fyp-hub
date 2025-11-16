import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_hub/models/app_user.dart';
import 'package:fyp_hub/models/student.dart';
import 'package:fyp_hub/models/supervisor.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference _usersRef;

  UserService() {
    _usersRef = _db.collection('users');
  }

  Future<void> createUserProfile(AppUser user) async {
    try {
      String uid = user.uid;
      Map<String, dynamic> userData = user.toJson();
      await _usersRef.doc(uid).set(userData);
    } catch (e) {
      print("Error creating user profile: $e");
      rethrow;
    }
  }

  Future<AppUser?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _usersRef.doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AppUser.fromJson(data);
      } else {
        print("No user found with UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error getting user profile: $e");
      return null;
    }
  }

  // FUNCTION 1: A STREAM
  Stream<AppUser?> getUserProfileStream(String uid) {
    return _usersRef.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return AppUser.fromJson(data);
      }
      return null; // No profile found
    });
  }

  // FUNCTION 2: UPDATE PROFILE
  Future<void> updateUserProfile(
    String uid,
    Map<String, dynamic> dataToUpdate,
  ) async {
    try {
      await _usersRef.doc(uid).update(dataToUpdate);
    } catch (e) {
      print("Error updating user profile: $e");
      rethrow;
    }
  }

  // FUNCTION 3: CHECK IF PROFILE IS COMPLETE
  bool isProfileComplete(AppUser user) {
    if (user is Student) {
      return user.domain.isNotEmpty && user.skills.isNotEmpty;
    }
    if (user is Supervisor) {
      return user.interests.isNotEmpty && user.availability.isNotEmpty;
    }
    return false;
  }
}
