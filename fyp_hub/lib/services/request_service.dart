import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_hub/models/request.dart';

class RequestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. SEND A REQUEST
  Future<void> sendRequest(Request request) async {
    try {
      await _db
          .collection('requests')
          .doc(request.requestId)
          .set(request.toJson());
    } catch (e) {
      print("Error sending request: $e");
      rethrow;
    }
  }

  // 2. GET MY INBOX (Requests sent TO me)
  Stream<List<Request>> getMyInboxStream(String myUid) {
    return _db
        .collection('requests')
        .where('receiverId', isEqualTo: myUid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Request.fromJson(doc.id, doc.data()))
              .toList(),
        );
  }

  // 3. UPDATE REQUEST STATUS (Accept/Decline)
  Future<void> updateRequestStatus(String requestId, String newStatus) async {
    try {
      await _db.collection('requests').doc(requestId).update({
        'status': newStatus,
      });
    } catch (e) {
      print("Error updating request: $e");
      rethrow;
    }
  }

  // 4. GET MY SENT REQUESTS (Requests I sent)
  Stream<List<Request>> getMySentRequestsStream(String myUid) {
    return _db
        .collection('requests')
        .where('senderId', isEqualTo: myUid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Request.fromJson(doc.id, doc.data()))
              .toList(),
        );
  }
}
