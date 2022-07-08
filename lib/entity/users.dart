import 'package:flutter/painting.dart';
import 'package:flutter_application_1/entity/base.dart';

class User extends Entity {
  String? firstName;
  String? lastName;
  String email;
  String? avatarUrl = '';
  bool online;
  int lastActivity;

  User.fromJson(userData)
      : this(
          userData['id'],
          email: userData['email'],
          online: userData['online'],
          firstName: userData['first_name'],
          lastName: userData['last_name'],
          avatarUrl: userData['avatar_url'],
          lastActivity: userData['last_activity'],
        );

  User(int? id,
      {required this.email,
      required this.online,
      this.firstName = '',
      this.lastName = '',
      this.avatarUrl = '',
      this.lastActivity = 0})
      : super(id);
}
