import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_hub/models/app_user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;

  UserService() {
    _usersRef = _db.collection('users');
  }

  Future<void> createUserProfile(AppUser user) async {
    try {
      // 1. Get the user's UID from the user object
      String uid = user.uid;

      // 2. Call user.toJson() - this automatically gets the
      Map<String, dynamic> userData = user.toJson();

      // 3. Go to the 'users' collection, find the document with
      await _usersRef.doc(uid).set(userData);
    } catch (e) {
      // 4. Handle any errors (e.g., permission denied)
      print("Error creating user profile: $e");
      rethrow;
    }
  }

  // 5. Get User Profile
  Future<AppUser?> getUserProfile(String uid) async {
    try {
      // 1. Go to the 'users' collection and get the document
      DocumentSnapshot doc = await _usersRef.doc(uid).get();

      // 2. Check if the document actually exists
      if (doc.exists) {
        // 3. Get the data from the document.
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // 4. THIS IS THE MAGIC:
        return AppUser.fromJson(data);
      } else {
        // 5. If no document was found for that UID
        print("No user found with UID: $uid");
        return null;
      }
    } catch (e) {
      // 6. Handle any errors (e.g., permission denied)
      print("Error getting user profile: $e");
      return null;
    }
  }
}
