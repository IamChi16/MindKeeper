import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ImageService {
  final _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(File imageFile) async{
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    DocumentReference docRef = await _firestore.collection('images').add({
      'image': base64Image,
      'created_at': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }
}