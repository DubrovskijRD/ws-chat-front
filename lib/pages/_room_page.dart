import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/entity/chat.dart';
import 'package:flutter_application_1/services/websocket.dart';
import 'package:flutter_application_1/widgets/room.dart';
import 'package:flutter_application_1/widgets/utils.dart';
import 'package:provider/provider.dart';




class RoomPageArgument {
  final int roomId;
  RoomPageArgument(this.roomId);
}

class RoomPage extends StatefulWidget {
  int roomId;
  RoomPage({Key? key, required this.roomId}) : super(key: key);

static const routeName = '/chat/room';
@override
  _RoomPageState createState() => _RoomPageState();
}


class _RoomPageState extends State<RoomPage> {
  TextEditingController messageController = TextEditingController();

  bool lockButton = false;
  bool lockButtonConfirm = true; 

  @override
  void initState() {
    super.initState();
    AppState appState = Provider.of<AppState>(context, listen: false);
    Future(() {
      if (!appState.authService.isLogin()) {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: messageList(widget.roomId)),
            TextInput(
              controller: messageController, inputLabel: 'message',
            ),
            ElevatedButton(onPressed: ()=>{sendMessage()}, child: Text("=>")),
                            
          ],
        ),
      ),
    );
  }

  void sendMessage(){
    String body = messageController.text;
    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.socket.sendCommand(Command("message", {"room_id": widget.roomId, "msg_type": 1, "msg_body": body}, "create"));
    messageController.clear();
  }

  Widget messageList(int roomId) {
    return Consumer<RoomStore>(
      builder: (context, roomStore, child) {
        Room? room = roomStore.getEntity(roomId);
        if (room == null){
          return const Text("Ooops? this rooms doesn't exists");
        }
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: room.messages.length,
            itemBuilder: (BuildContext context, int index) {
              return MessageWidget(room.messages[index]);
            });
      }

    );
  }

  // Widget messageList(int roomId){
  //   return Column(children: [
  //     Selector<RoomStore, List<Message>>(
  //                     selector: (_, provider) => provider.rooms[roomId]!.messages,
  //                     builder: (context, messages, child) {
  //                       print('Build num1');
  //                       return Expanded(child: ListView.builder(padding: const EdgeInsets.all(8),
  //                       itemCount: messages.length,
  //                       itemBuilder: (BuildContext context, int index) {
  //             return MessageWidget(messages[index]);
  //           }));})

  //   ],);
    
  // }
}