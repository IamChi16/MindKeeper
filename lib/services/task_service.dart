import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/tasks_model.dart';
import '../models/subtask_model.dart';

class TaskService {
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  User? user = FirebaseAuth.instance.currentUser;

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
        .where('isCompleted', isEqualTo: false)
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
        .where('isCompleted', isEqualTo: false)
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
}
