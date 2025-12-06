// lib/services/marketplace_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/marketplace_post.dart';
import '../models/supervisor.dart';

class MarketplaceService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- WRITE ---
  Future<void> createPost(MarketplacePost post) async {
    await _db
        .collection('marketplacePosts')
        .doc(post.postId)
        .set(post.toJson());
  }

  // --- READ ---

  // 1. Get Project Ideas
  Stream<List<MarketplacePost>> getProjectIdeas() {
    return _db
        .collection('marketplacePosts')
        .where('type', isEqualTo: 'projectIdea')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MarketplacePost.fromJson(doc.id, doc.data()))
              .toList(),
        );
  }

  // 2. Get Teammate Posts
  Stream<List<MarketplacePost>> getTeammatePosts() {
    return _db
        .collection('marketplacePosts')
        .where('type', isEqualTo: 'findTeammate')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MarketplacePost.fromJson(doc.id, doc.data()))
              .toList(),
        );
  }

  // 3. Get Supervisors
  Stream<List<Supervisor>> getAllSupervisors() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'supervisor')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Supervisor.fromJson(doc.data()))
              .toList(),
        );
  }
}
