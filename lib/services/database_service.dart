import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/category_model.dart';
import 'package:reminder_app/models/group_model.dart';
import 'package:reminder_app/models/tasks_model.dart';

import '../models/member_model.dart';
import '../models/subtask_model.dart';

class DatabaseService {
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<String> addTodoTask(String title, String description, String? priority,
      DateTime? dueDate, TimeOfDay? time) async {
    dueDate ??= DateTime.now();
    time ??= TimeOfDay.now();
    final String formattedDueDate = DateFormat('EEE, d MMMM').format(dueDate);

    if (title.isEmpty) {
      throw Exception('Title cannot be empty');
    }

    final taskDoc = await taskCollection.add({
      'uid': user!.uid,
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': false,
      'time': '${time.hour}:${time.minute}',
      'duedate': formattedDueDate,
    });

    return taskDoc.id; // Return the taskId
  }

  //update task
  Future<void> updateTask(String id, String title, String description,
      String priority, DateTime? duedate, TimeOfDay? time) async {
    final String formattedDueDate = DateFormat('EEE, d MMMM').format(duedate!);
    return await taskCollection.doc(id).update({
      'title': title,
      'description': description,
      'priority': priority,
      'duedate': formattedDueDate,
      'time': '${time!.hour}:${time.minute}',
    });
  }

  Future<void> updateTaskStatus(String id, bool isCompleted) async {
    return await taskCollection.doc(id).update({
      'isCompleted': isCompleted,
    });
  }

  Future<void> updateTaskPriority(String id, String priority) {
    return taskCollection.doc(id).update({
      'priority': priority,
    });
  }

  Future<void> updateTaskDueDate(String id, String duedate) {
    return taskCollection.doc(id).update({
      'duedate': duedate,
    });
  }

  //delete task
  Future<void> deleteTask(String id) async {
    final deleteTasksCollection =
        FirebaseFirestore.instance.collection('tasks').doc(id);
    return await deleteTasksCollection.delete();
  }

  //get pending tasks
  Stream<List<Task>> get tasks {
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Future<int> countTotalTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .get();
    return querySnapshot.docs.length;
  }

  Future<int> countPendingTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: false)
        .get();
    return querySnapshot.docs.length;
  }

  //get completed tasks
  Stream<List<Task>> get completedtasks {
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Future<int> countCompletedTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: true)
        .get();
    return querySnapshot.docs.length;
  }

  Stream<List<Task>> get todaytasks {
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM').format(DateTime.now()))
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Future<int> countTodayPendingTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: false)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM').format(DateTime.now()))
        .get();
    return querySnapshot.docs.length;
  }

  Future<int> countTodayCompletedTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: true)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM').format(DateTime.now()))
        .get();
    return querySnapshot.docs.length;
  }

  Future<int> countTodayTotalTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM').format(DateTime.now()))
        .get();
    return querySnapshot.docs.length;
  }

  Stream<List<Task>> get tomorrowtasks {
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM')
                .format(DateTime.now().add(const Duration(days: 1))))
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Future<int> countTomorrowPendingTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: false)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM')
                .format(DateTime.now().add(const Duration(days: 1))))
        .get();
    return querySnapshot.docs.length;
  }

  Stream<List<Task>> get weektasks {
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('duedate',
            isGreaterThanOrEqualTo:
                DateFormat('EEE, d MMMM').format(DateTime.now()),
            isLessThanOrEqualTo: DateFormat('EEE, d MMMM')
                .format(DateTime.now().add(const Duration(days: 7))))
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Future<int> countWeekPendingTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: false)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM')
                .format(DateTime.now().add(const Duration(days: 7))))
        .get();
    return querySnapshot.docs.length;
  }

  Future<int> countWeekCompletedTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: true)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM')
                .format(DateTime.now().add(const Duration(days: 7))))
        .get();
    return querySnapshot.docs.length;
  }

  Future<int> countWeekTotalTasks() async {
    final querySnapshot = await taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM')
                .format(DateTime.now().add(const Duration(days: 7))))
        .get();
    return querySnapshot.docs.length;
  }


  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      // final DateTime dueDateTime = DateTime.parse(doc['duedate']);
      return Task(
        id: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        priority: doc['priority'] ?? 'default',
        time: doc['time'] ?? '',
        duedate:
            doc['duedate'] ?? DateFormat('EEE, d MMMM').format(DateTime.now()),
        isCompleted: doc['isCompleted'] ?? false,
      );
    }).toList();
  }

  //add subtask
  Future<DocumentReference> addSubTask(String taskId, String title) async {
    return await taskCollection.doc(taskId).collection('subtasks').add({
      'title': title,
      'isCompleted': false,
    });
  }

  //get subtasks
  Stream<List<SubTask>> getSubTasks(String taskId) {
    return taskCollection
        .doc(taskId)
        .collection('subtasks')
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map(_subTaskListFromSnapshot);
  }

  //update subtask
  Future<void> updateSubTask(String taskId, String subTaskId, String title) {
    return taskCollection
        .doc(taskId)
        .collection('subtasks')
        .doc(subTaskId)
        .update({
      'title': title,
    });
  }

  Future<void> updateSubTaskStatus(
      String taskId, String subTaskId, bool isCompleted) {
    return taskCollection
        .doc(taskId)
        .collection('subtasks')
        .doc(subTaskId)
        .update({
      'isCompleted': isCompleted,
    });
  }

  //delete subtask
  Future<void> deleteSubTask(String taskId, String subTaskId) async {
    return await taskCollection
        .doc(taskId)
        .collection('subtasks')
        .doc(subTaskId)
        .delete();
  }

  List<SubTask> _subTaskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SubTask(
        id: doc.id,
        title: doc['title'] ?? '',
        isCompleted: doc['isCompleted'] ?? false,
      );
    }).toList();
  }

  //add category
  Future<DocumentReference> addCategory(String name, Color color) async {
    return await categoryCollection.add({
      'uid': user!.uid,
      'name': name,
      'color': color.value,
    });
  }

  //get categories

//   Future<List<Category>> getCategories() async {
//   final querySnapshot = await categoryCollection.get();
//   return querySnapshot.docs.map((doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Category(
//       id: doc.id,
//       name: data['name'],
//       color: Color(data['color'] ?? 0xFFFFFFFF),
//     );
//   }).toList();
// }

  Stream<List<Category>> get categories {
    return categoryCollection
        .where('uid', isEqualTo: user!.uid)
        .snapshots()
        .map(_categoryListFromSnapshot);
  }

  List<Category> _categoryListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Category(
        id: doc.id,
        name: doc['name'] ?? '',
        color: Color(doc['color'] ?? 0xFFFFFFFF),
      );
    }).toList();
  }

  //update category
  Future<void> updateCategory(String id, String name, Color color) async {
    final updateCategoryCollection =
        FirebaseFirestore.instance.collection('categories').doc(id);
    return await updateCategoryCollection
        .update({'name': name, 'color': color});
  }

  //delete category
  Future<void> deleteCategory(String id) async {
    return await FirebaseFirestore.instance
        .collection('categories')
        .doc(id)
        .delete();
  }

  //add task to category
  Future<void> addTaskToCategory(String categoryId, String taskId) async {
    return await categoryCollection
        .doc(categoryId)
        .collection('tasks')
        .doc(taskId)
        .set({});
  }

  //get tasks in category
  Stream<List<Task>> getTasksInCategory(String categoryId) {
    return categoryCollection
        .doc(categoryId)
        .collection('tasks')
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  //delete task from category
  Future<void> deleteTaskFromCategory(String categoryId, String taskId) async {
    return await categoryCollection
        .doc(categoryId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  //add Group
  Future<DocumentReference> createGroup(String name, String description) async {
    return await groupCollection.add({
      'uid': user!.uid,
      'name': name,
      'description': description,
    });
  }

  //get group
  Stream<Group> getGroup(String id) {
    return groupCollection.doc(id).snapshots().map(_groupFromSnapshot);
  }

  Group _groupFromSnapshot(DocumentSnapshot snapshot) {
    return Group(
      id: snapshot.id,
      name: snapshot['name'] ?? '',
      description: snapshot['description'] ?? '',
    );
  }

  //update Group
  Future<void> updateGroup(String id, String name, String description) async {
    final updateGroupCollection =
        FirebaseFirestore.instance.collection('groups').doc(id);
    return await updateGroupCollection.update({
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

  //get groups
  Stream<List<Group>> get groups {
    return groupCollection
        .where('uid', isEqualTo: user!.uid)
        .snapshots()
        .map(_groupListFromSnapshot);
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

  //add member
  Future<void> addMemberToGroup(
      BuildContext context, String groupId, String email) async {
    try {
      // Check if the user exists
      String? userId = await getUserIdByEmail(email);
      if (userId != null) {
        // Send in-app notification to the registered user
        await sendInAppNotification(userId, groupId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invitation sent to $email')),
        );
      } else {
        // Show message if the email is not registered
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('The email $email is not registered in the app.')),
        );
      }
    } catch (e) {
      print("Error adding member: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  Future<String?> getUserIdByEmail(String email) async {
    var query = await userCollection.where('email', isEqualTo: email).get();
    if (query.docs.isNotEmpty) {
      return query.docs.first.id; // Return the user ID
    }
    return null; // User not found
  }

// Mock function to send in-app notification
  Future<void> sendInAppNotification(String userId, String groupId) async {
    // Implement in-app notification logic
    await notificationsCollection.add({
      'userId': userId,
      'groupId': groupId,
      'message': 'You have been invited to join a group.',
      'status': 'pending',
    });
  }

  Future<void> sendFCMNotification(
      String userId, String title, String body) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String? deviceToken = userDoc.data()?['deviceToken'];

    if (deviceToken == null) {
      throw Exception('User does not have a registered device token.');
    }

    const String serverKey = 'YOUR_SERVER_KEY';
    final Uri fcmUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final response = await http.post(
      fcmUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: '''
    {
      "to": "$deviceToken",
      "notification": {
        "title": "$title",
        "body": "$body"
      }
    }
    ''',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send FCM notification: ${response.body}');
    }
  }

  Future<void> sendEmailInvitation(String email, String groupName) async {
    final emailData = {
      'to': email,
      'message': {
        'subject': 'Invitation to join our app',
        'text':
            'You have been invited to join the group $groupName in our app.',
      },
    };

    await FirebaseFirestore.instance.collection('mail').add(emailData);
  }

  // Future<void> saveDeviceToken(String userId) async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   if (token != null) {
  //     await FirebaseFirestore.instance.collection('users').doc(userId).update({
  //       'deviceToken': token,
  //     });
  //   }
  // }

  //update member role
  Future<void> updateMemberRole(
      String groupId, String memberId, String role) async {
    try {
      await groupCollection
          .doc(groupId)
          .collection('members')
          .doc(memberId)
          .update({'role': role});
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
        'uid': user!.uid,
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
