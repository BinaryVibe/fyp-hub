import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String requestId;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String type; // 'teammate' or 'supervisor'
  final String status; // 'pending', 'accepted', 'declined', 'approved'
  final String message;
  final Timestamp? proposedTime;

  // --- CONSTRUCTOR ---
  Request({
    required this.requestId,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.message,
    this.proposedTime,
  });

  // --- JSON METHODS ---
  factory Request.fromJson(String id, Map<String, dynamic> json) {
    return Request(
      requestId: id,
      senderId: json['senderId'],
      senderName: json['senderName'],
      receiverId: json['receiverId'],
      type: json['type'],
      status: json['status'],
      message: json['message'],
      proposedTime: json['proposedTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'type': type,
      'status': status,
      'message': message,
      'proposedTime': proposedTime,
    };
  }

  // --- OTHER METHODS ---
  @override
  String toString() {
    return 'Request from $senderName (Type: $type, Status: $status)';
  }
}
