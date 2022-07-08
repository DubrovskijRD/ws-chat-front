import 'dart:convert' as convert;
import 'package:flutter_application_1/config.dart' as config;
import 'package:flutter_application_1/entity/auth.dart';
import 'package:flutter_application_1/services/device_data.dart';
import 'package:http/http.dart' as http;

class AuthError implements Exception {
  Map<String, dynamic> message;
  AuthError(this.message);
  @override
  String toString() {
    return "Auth error $message";
  }
}

Future<void> logout(int id, String token) async {
  const String path = '/logut';
  // method for del api token, not working yet
  
}

Future<SessionData> login(String email, String password) async {
  const String path = '/login';
  var url = Uri.http(config.host, path);
  // var url = Uri.https(host, path);
  DeviceData deviceData = DeviceData();
  await deviceData.initPlatformState();

  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: convert.jsonEncode(
      {
        "email": email,
        "password": password,
        "device_info": deviceData.deviceData
      },
    ),
  );
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    if (jsonResponse['status'] == 'success') {
      return SessionData(email, jsonResponse['data']['token'], jsonResponse['data']['id']);
    } else {
      throw AuthError(jsonResponse['error']);
    }
  } else {
    throw Exception("login error ${response.statusCode}");
  }
}


Future<bool> register(String email, String password) async {
  const String path = '/register';
  var url = Uri.http(config.host, path);
  // var url = Uri.https(host, path);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: convert.jsonEncode(
      {
        "email": email,
        "password": password,
      },
    ),
  );
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    if (jsonResponse['status'] == 'success') {
      return true;
    } else {
      throw AuthError(jsonResponse['error']);
    }
  } else {
    throw Exception("login error ${response.statusCode}");
  }
}


Future<bool> confirm(String confirmCode) async {
  const String path = '/confirm';
  var query = {
        "code": confirmCode,
      };
  var url = Uri.http(config.host, path, query);
  
  // var url = Uri.https(host, path);
  var response = await http.get(
    url,
    headers: {"Content-Type": "application/json"},
  );
  if (response.statusCode == 200) {
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    if (jsonResponse['status'] == 'success') {
      return true;
    } else {
      throw AuthError(jsonResponse['error']);
    }
  } else {
    throw Exception("confirm error ${response.statusCode}");
  }
}