// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app.dart';
// import 'package:flutter_application_1/entity/chat.dart';
// import 'package:flutter_application_1/entity/users.dart';
// import 'package:flutter_application_1/pages/room_page.dart';
// import 'package:flutter_application_1/services/websocket.dart';
// import 'package:provider/provider.dart';

// class UserWidget extends StatelessWidget {
//   User user;
//   bool isFrined;
//   bool needStartChating;
//   UserWidget(this.user,
//       {Key? key, this.isFrined = true, this.needStartChating = false})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 350,
//       height: 40,
//       decoration: BoxDecoration(
//           border: Border.all(
//         color: Colors.grey,
//         width: 1,
//       )),
//       child: Row(
//         children: [
//           Text("${user.email}"),
//           isFrined
//               ? TextButton(
//                   child: Text("chating:)!"),
//                   onPressed: needStartChating
//                       ? () {
//                           _startChating(context);
//                         }
//                       : null,
//                 )
//               : TextButton(
//                   child: Text("add frined:)!"),
//                   onPressed: () =>
//                       {print("$user.id : ${user.email} - add friend button")},
//                 )
//         ],
//       ),
//     );
//   }

//   void _startChating(BuildContext context) {
//     int? roomId = getOrCreateRoom(context, user.id);
//     if (roomId != null) {
//       Navigator.pushNamed(context, RoomPage.routeName,
//           arguments: RoomPageArgument(roomId));
//     }
//   }

//   int? getOrCreateRoom(BuildContext context, int? userId) {
//     if (userId == null) {
//       return -1;
//     }
//     RoomStore roomStorage = Provider.of<RoomStore>(context, listen: false);
//     for (var i = 0; i < roomStorage.length; i++) {
//       Room room = roomStorage.getEntityByIndex(i);
//       if (room.containsMember(userId)) {
//         return room.id;
//       }
//     }
//     String resource = "room";
//     String addFrinedCommandUid = "createRoom#$userId";
//     String action = "create";
//     Map<String, dynamic> payload = {
//       "members_id": [userId],
//       "private": true
//     };
//     AppState appState = Provider.of<AppState>(context, listen: false);
//     appState.socket.sendCommand(
//         Command(resource, payload, action, uid: addFrinedCommandUid));
//     return null;
//   }
// }
