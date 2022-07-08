import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  setUrlStrategy(PathUrlStrategy());
  AuthService authService = AuthService();
  await authService.init();


  runApp(
    ChatApp(
      authService,
    ),
  );
}
