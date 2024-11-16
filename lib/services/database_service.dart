import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/group_model.dart';
import 'package:reminder_app/models/tasks_model.dart';

class DatabaseService {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');

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
  Future<void> updateTask(
      String id, String title, String description, String priority) async {
    final updateTasksCollection =
        FirebaseFirestore.instance.collection('tasks').doc(id);
    try {
      if (title.isEmpty) {
        throw Exception('Title cannot be empty');
      }
      return await updateTasksCollection.update({
        'title': title,
        'description': description,
        'priority': priority,
      });
    } on Exception catch (e) {
      throw e;
    }
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
        .where('duedate', isEqualTo: DateFormat('EEE, d MMMM').format(DateTime.now()))
        .snapshots()
        .map(_taskListFromSnapshot);
  }
  Stream<List<Task>> get tomorrowtasks {
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('duedate', isEqualTo: DateFormat('EEE, d MMMM').format(DateTime.now().add(Duration(days: 1))))
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

  //add Group
  Future<DocumentReference> addGroup(
      String name, String description, Image image) async {
    return await groupCollection.add({
      'uid': user!.uid,
      'name': name,
      'description': description,
      'image': image,
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
    return taskCollection
        .where('uid', isEqualTo: user!.uid)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map(_groupListFromSnapshot);
  }

  List<Group> _groupListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Group(
        id: doc.id,
        name: doc['name'] ?? '',
        description: doc['description'] ?? '',
        image: doc['image'] ?? '',
      );
    }).toList();
  }
}
