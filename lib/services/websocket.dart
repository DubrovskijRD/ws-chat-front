import 'dart:convert' as convert;
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

String wsUrl = "ws://$host/api/connect";

class WsMessage {
  String resource;
  String action;
  Map<String, dynamic> payload;

  WsMessage(this.resource, this.action, this.payload);
}

class Query {
  final String type = "query";
  String resource;
  Map<String, dynamic> payload;
  String uid;

  Query(this.resource, this.payload, {this.uid = '-'});
}

class Command {
  final String type = "command";
  String resource;
  String action;
  Map<String, dynamic> payload;
  String uid;
  Command(this.resource, this.payload, this.action, {this.uid = '-'});
}

class WebSocket {
  bool connected = false;
  ConnectState connectState;
  late WebSocketChannel _channel;
  QueryResponseMap queryResponseMap;

  WebSocket(this.queryResponseMap, this.connectState);

  connect(String token, Function messageListener) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse("$wsUrl?sid=$token"));

      connected = true;
      connectState.conected = true;
      // connectionListener(_instance, _connected);
      print('websocket connected');
      _channel.stream.listen(
        (message) {
          print('websocket receive $message');
          messageListener(convert.jsonDecode(message));
        },
        onDone: () {
          connected = false;
          connectState.conected = false;
          // connectionListener(_instance, _connected);
          print('websocket closed');
        },
        onError: (error) {
          print('websocket error $error');
          throw error;
        },
      );
    } catch (e) {
      print('websocket exception $e');
      connected = false;
      // connectionListener(_connected);
    }
  }

  bool send(WsMessage message) {
    try {
      if (_channel == null) throw ('_channel undefined');
      _channel.sink.add(convert.jsonEncode({
        "resource": message.resource,
        "action": message.action,
        "payload": message.payload
      }));
      return true;
    } catch (e) {
      return false;
    }
  }

  bool sendQuery(Query query) {
    try {
      if (_channel == null) throw ('_channel undefined');
      _channel.sink.add(convert.jsonEncode({
        "type": query.type,
        "resource": query.resource,
        "payload": query.payload,
        "uid": query.uid
      }));
      queryResponseMap.set(query.uid, null);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool sendCommand(Command command) {
    try {
      if (_channel == null) throw ('_channel undefined');
      _channel.sink.add(convert.jsonEncode({
        "type": command.type,
        "resource": command.resource,
        "payload": command.payload,
        "uid": command.uid,
        "action": command.action
      }));
      // queryResponseMap.set(command.uid, null);
      return true;
    } catch (e) {
      return false;
    }
  }

  close() {
    if (connected) {
      _channel.sink.close(status.normalClosure);
    }
  }
}
