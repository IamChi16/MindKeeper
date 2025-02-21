import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mind_keeper/models/category_model.dart';

class CategoryService {
  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');
  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  User? user = FirebaseAuth.instance.currentUser;

  //add category
  Future<DocumentReference> addCategory(String name, Color color) async {
    return await categoryCollection.add({
      'uid': user!.uid,
      'name': name,
      'color': color.value,
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
      final data = doc.data() as Map<String, dynamic>;
      return Category(
        id: doc.id,
        name: doc['name'] ?? '',
        color: Color(doc['color'] ?? 0xFFFFFFFF),
      );
    }).toList();
  }

  Future<List<Category>> getCategories() async {
    final querySnapshot = await categoryCollection
        .where('uid', isEqualTo: user!.uid)
        .get(); // Filter by the current user's ID

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Category(
        id: doc.id,
        name: data['name'],
        color: Color(
            data['color'] ?? 0xFFFFFFFF), // Default to white if color is null
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
    final taskDoc = FirebaseFirestore.instance.collection('tasks').doc(taskId);
    final taskSnapshot = await taskDoc.get();

    if (taskSnapshot.exists) {
      final taskData = taskSnapshot.data();
      return await categoryCollection
          .doc(categoryId)
          .collection('tasks')
          .doc(taskId)
          .set(taskData!);
    } else {
      throw Exception('Task does not exist');
    }
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
