import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/entity/chat.dart';
import 'package:flutter_application_1/entity/users.dart';
import 'package:provider/provider.dart';

class _RoomWidget extends StatelessWidget {
  Room room;

  _RoomWidget(this.room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? chatId;
    String? tmpRoomName;
    AppState appState = Provider.of<AppState>(context, listen: false);
    int? myId = appState.authService.getId();

    for (int userId in room.members) {
      if (userId != myId) {
        tmpRoomName = appState.userStore.getEntity(userId)?.email;
      }
    }
    return Container(
        width: 350,
        height: 40,
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.grey,
          width: 1,
        )),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Text("Chat with: "),
          Text(tmpRoomName ?? "???"),
        ]));
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;
  const MessageWidget(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String senderName;
    AppState appState = Provider.of<AppState>(context, listen: false);
    if (message.creatorId == appState.authService.getId()) {
      senderName = "ME :)";
    } else {
      User? sender = appState.userStore.getEntity(message.creatorId);
      senderName = sender?.email ?? "???";
    }
    return Row(
      children: [Text(message.body), Text(senderName)],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}

class RoomViewWidget extends StatelessWidget {
  Room room;

  RoomViewWidget(this.room, {Key? key}) : super(key: key);

  String getRoomLabel(room, members) {
    return room.name;
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    int? myId = appState.authService.getId();
    EntityStore<User> userStore = Provider.of<EntityStore<User>>(context);
    String? tmpRoomLabel;
    if (room.name != null) {
      tmpRoomLabel = room.name!;
    } else {
      for (int userId in room.members){
        if (userId != myId){
          tmpRoomLabel = userStore.getEntity(userId)?.email;
        }
      }
    }
    String lastMessageTime;
    try {
      Message lastMessage = room.messages.last;
      lastMessageTime = DateTime.fromMillisecondsSinceEpoch(lastMessage.createdAt * 1000).toString();
    } on StateError {
      lastMessageTime = '';
    }
    String roomLabel = tmpRoomLabel ?? "???";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8, 8, 12, 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                child: Text(
                  roomLabel,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: Color(0xFF1D2429),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                 lastMessageTime,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
