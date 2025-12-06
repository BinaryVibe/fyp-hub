import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_hub/models/marketplace_post.dart';
import '../models/supervisor.dart';

class MarketplaceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Get All Supervisors
  Stream<List<Supervisor>> getAllSupervisors() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'supervisor') // Filter by role
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Supervisor.fromJson(doc.data()))
              .toList(),
        );
  }

  // (We will add methods for Projects and Teammates here later)
  // Add this inside your MarketplaceService class
  Future<void> createPost(MarketplacePost post) async {
    await _db
        .collection('marketplacePosts')
        .doc(post.postId)
        .set(post.toJson());
  }
}
