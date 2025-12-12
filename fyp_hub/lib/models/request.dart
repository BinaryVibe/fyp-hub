import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String requestId;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName; // 1. Add this
  final String type; 
  final String status; 
  final String message;
  final Timestamp? proposedTime;

  Request({
    required this.requestId,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName, // 2. Add to constructor
    required this.type,
    required this.status,
    required this.message,
    this.proposedTime,
  });

  factory Request.fromJson(String id, Map<String, dynamic> json) {
    return Request(
      requestId: id,
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? 'Unknown',
      receiverId: json['receiverId'] ?? '',
      // 3. Retrieve it (Safety check for old data)
      receiverName: json['receiverName'] ?? 'Unknown User', 
      type: json['type'] ?? 'teammate',
      status: json['status'] ?? 'pending',
      message: json['message'] ?? '',
      proposedTime: json['proposedTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'receiverName': receiverName, // 4. Save it
      'type': type,
      'status': status,
      'message': message,
      'proposedTime': proposedTime,
    };
  }
}