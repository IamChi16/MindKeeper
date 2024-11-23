import 'package:reminder_app/models/user_model.dart';

class Member extends Users {
  final String? role;

  Member({
    required super.uid,
    required super.email,
    required super.name,
    this.role,
  });
  
}