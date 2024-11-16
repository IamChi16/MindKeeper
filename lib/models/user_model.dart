import 'dart:io';

class Users{
  final String uid;
  final String email;
  final String name;
  final File? photoUrl;


  Users({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
  });
}