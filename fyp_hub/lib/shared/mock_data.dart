import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_hub/models/request.dart';

class MockData {
  // This list pretends to be data coming from Firestore
  static List<Request> myRequests = [
    Request(
      requestId: 'req1',
      senderId: 'user_101',
      senderName: 'John Student',
      receiverId: 'me',
      type: 'teammate',
      status: 'pending',
      message: 'Hi, I am a backend dev. Can I join your AI project?',
      proposedTime: null,
    ),
    Request(
      requestId: 'req2',
      senderId: 'user_202',
      senderName: 'Dr. Smith',
      receiverId: 'me',
      type: 'supervisor',
      status: 'accepted', // ALREADY ACCEPTED
      message: 'I have accepted your meeting request.',
      proposedTime: Timestamp.now(),
    ),
  ];
}