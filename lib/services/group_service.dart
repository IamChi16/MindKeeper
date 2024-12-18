import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/group_model.dart';
import 'package:uuid/uuid.dart';

import '../models/member_model.dart';

class GroupService {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String groupId = Uuid().v1();

  //add Group
  Future<void> addGroup(List<Map<String, dynamic>> membersList,
      String groupName, String description) async {
    List<Map<String, dynamic>> membersList = [
      {
        "uid": _auth.currentUser!.uid,
        "name": _auth.currentUser!.displayName,
        "email": _auth.currentUser!.email,
        "isAdmin": true,
      }
    ];

    await _firestore.collection('groups').doc(groupId).set({
      "members": membersList,
      "id": groupId,
      "name": groupName,
      "description": description,
    });

    for (int i = 0; i < membersList.length; i++) {
      String uid = membersList[i]['uid'];

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        "id": groupId,
      });
    }

    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      "message": "${_auth.currentUser!.displayName} Created This Group.",
      "type": "notify",
    });
  }

  //get group

  //update Group
  Future<void> updateGroup(String id, String name, String description) async {
    return await groupCollection.doc(id).update({
      'name': name,
      'description': description,
    });
  }

  //delete group
  Future<void> deleteGroup(String id) async {
    return await FirebaseFirestore.instance
        .collection('groups')
        .doc(id)
        .delete();
  }

  Stream<List<Group>> getGroups() {
    return groupCollection.snapshots().map(_groupListFromSnapshot);
}

List<Group> _groupListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    return Group(
      id: doc.id,
      name: doc['name'] ?? '',
      description: doc['description'] ?? '',
    );
  }).toList();
}


  //update member role
  Future<void> updateMemberRole(
      String groupId, String memberId, String role) async {
    try {
      DocumentSnapshot groupSnapshot = await groupCollection.doc(groupId).get();
      List members = groupSnapshot['members'];

      // Cập nhật vai trò của thành viên trong danh sách
      for (var member in members) {
        if (member['uid'] == memberId) {
          member['role'] = role;
          break;
        }
      }

      // Ghi danh sách cập nhật lại Firestore
      await groupCollection.doc(groupId).update({'members': members});
    } catch (e) {
      throw Exception('Failed to update member role: $e');
    }
  }

// Check if the user exists in your app's user database
  Future<bool> checkUserExists(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.exists;
  }

  //get members
  Stream<List<Member>> getMembers(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection('members')
        .snapshots()
        .map(_memberListFromSnapshot);
  }

  List<Member> _memberListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Member(
        uid: doc.id,
        email: doc['email'] ?? '',
        name: doc['name'] ?? '',
        role: doc['role'] ?? '',
      );
    }).toList();
  }

  //delete member
  Future<void> deleteMember(String groupId, String memberId) async {
    return await groupCollection
        .doc(groupId)
        .collection('members')
        .doc(memberId)
        .delete();
  }

  //add task to group
  Future<DocumentReference> addTaskToGroup(String groupId, String title,
      String description, String? priority) async {
    final String formattedDueDate =
        DateFormat('EEE, d MMMM').format(DateTime.now());
    try {
      if (title.isEmpty) {
        throw Exception('Title cannot be empty');
      }
      return await groupCollection.doc(groupId).collection('todos').add({
        'title': title,
        'description': description,
        'priority': priority,
        'isCompleted': false,
        'time': '${DateTime.now().day}/${DateTime.now().month}',
        'duedate': formattedDueDate,
      });
    } on Exception {
      rethrow;
    }
  }

  // update task

  Future<void> updateGroupTask(String groupId, String taskId, String title,
      String description, String priority, DateTime? duedate) async {
    final String formattedDueDate = DateFormat('EEE, d MMMM').format(duedate!);
    return await groupCollection
        .doc(groupId)
        .collection('todos')
        .doc(taskId)
        .update({
      'title': title,
      'description': description,
      'priority': priority,
      'duedate': formattedDueDate,
    });
  }

  Future<void> shareTaskWithMember(
      String groupId, String taskId, String memberId, int order) async {
    await groupCollection.doc(groupId).collection('todos').doc(taskId).update({
      'assignedTo': memberId,
      'order': order,
    });
  }
}
