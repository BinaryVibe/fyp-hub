import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_hub/models/request.dart';
import 'package:fyp_hub/models/project.dart';     
import 'package:fyp_hub/models/milestone.dart';   

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
      status: 'accepted',
      message: 'I have accepted your meeting request.',
      proposedTime: Timestamp.now(),
    ),
  ];

  // --- MISSING PROJECT DATA (ADD THIS) ---
  static Project myProject = Project(
    projectId: 'proj_123',
    title: 'AI Traffic Control System',
    description: 'Using computer vision to optimize city traffic lights.',
    supervisorId: 'sup_01',
    supervisorName: 'Dr. Smith',
    teamLeadId: 'me',
    teamMembers: [
      {'uid': 'me', 'name': 'Me (Lead)'},
      {'uid': 'user_101', 'name': 'John Student'},
    ],
  );

  static List<Milestone> myMilestones = [
    Milestone(
      milestoneId: 'm1',
      title: 'Project Proposal',
      deadline: Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      status: 'Approved',
    ),
    Milestone(
      milestoneId: 'm2',
      title: 'Design Document (FYP-1)',
      deadline: Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
      status: 'Pending',
    ),
  ];
}