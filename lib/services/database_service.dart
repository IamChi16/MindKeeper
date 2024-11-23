import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/category_model.dart';
import 'package:reminder_app/models/group_model.dart';
import 'package:reminder_app/models/tasks_model.dart';

import '../models/member_model.dart';
import '../models/subtask_model.dart';

class DatabaseService {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentReference> addTodoTask(String title, String description,
      String? priority, DateTime? dueDate) async {
    dueDate ??= DateTime.now();
    final String formattedDueDate = DateFormat('EEE, d MMMM').format(dueDate);
    try {
      if (title.isEmpty) {
        throw Exception('Title cannot be empty');
      }
      return await taskCollection.add({
        'uid': user!.uid,
        'title': title,
        'description': description,
        'priority': priority,
        'isCompleted': false,
        'time': '${DateTime.now().day}/${DateTime.now().month}',
        'duedate': formattedDueDate,
      });
    } on Exception catch (e) {
      throw e;
    }
  }

  //update task
  Future<void> updateTask(String id, String title, String description,
      String priority, DateTime? duedate) async {
    final String formattedDueDate = DateFormat('EEE, d MMMM').format(duedate!);
    return await taskCollection.doc(id).update({
      'title': title,
      'description': description,
      'priority': priority,
      'duedate': formattedDueDate,
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

  //get completed tasks
  Stream<List<Task>> get completedtasks {
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Stream<List<Task>> get todaytasks {
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM').format(DateTime.now()))
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Stream<List<Task>> get tomorrowtasks {
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('duedate',
            isEqualTo: DateFormat('EEE, d MMMM')
                .format(DateTime.now().add(Duration(days: 1))))
        .snapshots()
        .map(_taskListFromSnapshot);
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
      'color': color,
    });
  }

  //get categories
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
        color: Color(doc['color']),
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
  Future<DocumentReference> createGroup(String name, String description,
      {String? imageId}) async {
    return await groupCollection.add({
      'uid': user!.uid,
      'name': name,
      'description': description,
      'photoId': imageId,
      'createdAt': FieldValue.serverTimestamp()
    });
  }

  //update Group
  Future<void> updateGroup(
      String id, String name, String description, Image image) async {
    final updateGroupCollection =
        FirebaseFirestore.instance.collection('groups').doc(id);
    return await updateGroupCollection.update({
      'name': name,
      'description': description,
      'image': image,
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

  //add photo group
  Future<void> saveImageUrl(String groupId, String imageId) async {
    await groupCollection.doc(groupId).update({
      'photoId': imageId,
    });
  }

  //add member
  Future<void> addMemberToGroup(String groupId, Member member) async {
    bool userExists = await checkUserExists(member.uid);

    if (userExists) {
      await groupCollection
          .doc(groupId)
          .collection('members')
          .doc(member.uid)
          .set({
        'email': member.email,
        'name': member.name,
        'role': member.role,
      });
    } else {
      throw Exception('User not registered in the app');
    }
  }

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
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> shareTaskWithMember(
      String groupId, String taskId, String memberId, int order) async {
    await groupCollection.doc(groupId).collection('todos').doc(taskId).update({
      'assignedTo': memberId,
      'order': order,
    });
  }
}
