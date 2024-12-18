import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/models/category_model.dart';
import 'package:reminder_app/models/tasks_model.dart';

class CategoryService {
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  User? user = FirebaseAuth.instance.currentUser;

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
}
