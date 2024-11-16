import 'dart:io';

import 'package:flutter/material.dart';

class Group{
  final String id;
  final String name;
  final String description;
  final File image;

  Group({required this.id, required this.name, required this.description, required this.image});
}