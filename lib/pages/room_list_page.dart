import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/entity/chat.dart';
import 'package:flutter_application_1/entity/users.dart';
import 'package:flutter_application_1/pages/room_page.dart';
import 'package:flutter_application_1/services/websocket.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RoomListPageWidget extends StatefulWidget {
  const RoomListPageWidget({Key? key}) : super(key: key);

  @override
  _RoomListPageWidgetState createState() => _RoomListPageWidgetState();
}

class _RoomListPageWidgetState extends State<RoomListPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    AppState appState = Provider.of<AppState>(context, listen: false);
    Future(() {
      if (!appState.authService.isLogin()) {
        Navigator.pushNamed(context, '/login');
      }
      appState.socket.sendQuery(Query('friend', {}, uid: "fq"));
      appState.socket.sendQuery(Query('room', {}, uid: "rq"));
      appState.socket.sendQuery(
          Query('friend_request', {"incoming": true, "outgoing": true}));
      // in this momet roomStore is empty
      // for (final room in appState.roomStore.rooms){
      //     appState.socket.sendQuery(Query('message', {"room_id": room.id}));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    ConnectState connectState = Provider.of<ConnectState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Icon(connectState.conected ? Icons.check_circle : Icons.warning),
      ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: Color(0xFF4B39EF),
                        unselectedLabelColor: Color(0xFF57636C),
                        labelStyle: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF1D2429),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        indicatorColor: Color(0xFF4B39EF),
                        tabs: [
                          Tab(
                            text: 'Чаты',
                          ),
                          Tab(
                            text: 'Друзья',
                          ),
                          // Tab(text: "Заявки")
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 44),
                                      child: Consumer<RoomStore>(
                                        builder: (context, roomStore, child) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.all(8),
                                              itemCount: roomStore.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                Room room = roomStore
                                                    .getEntityByIndex(index);
                                                return roomListElement(
                                                    room, context);
                                              });
                                        },
                                      )

                                      // ListView(
                                      //   padding: EdgeInsets.zero,
                                      //   primary: false,
                                      //   shrinkWrap: true,
                                      //   scrollDirection: Axis.vertical,
                                      //   children: [
                                      //     roomListElement("Penny Rubens"),
                                      //     roomListElement("Clar Kent"),
                                      //     roomListElement("Sally Sallivan"),
                                      //     roomListElement("Master of Puppets")
                                      //     ],
                                      // ),
                                      ),
                                ],
                              ),
                            ),
                            
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 12),
                                    child: Consumer<EntityStore<User>>(
                                        builder: (context, userStore, child) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(8),
                                          itemCount: userStore.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            User user = userStore
                                                .getEntityByIndex(index);
                                            return userListElement(
                                                user, context);
                                          });
                                    }),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 130,
                height: 40,
                margin: EdgeInsets.all(25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.transparent),
                  child: Text("Найти друзей"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/users/search');
                  },
                ),
              ),
              // FFButtonWidget(
              //   onPressed: () async {
              //     await Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => UsersWidget(),
              //       ),
              //     );
              //   },
              //   text: 'search',
              //   options: FFButtonOptions(
              //     width: 130,
              //     height: 40,
              //     color: FlutterFlowTheme.of(context).primaryColor,
              //     textStyle: FlutterFlowTheme.of(context).subtitle2.override(
              //           fontFamily: 'Poppins',
              //           color: Colors.white,
              //         ),
              //     borderSide: BorderSide(
              //       color: Colors.transparent,
              //       width: 1,
              //     ),
              //     borderRadius: 12,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget roomListElement(Room room, BuildContext context) {
    String label = "???";
    String? lastMessageDate = room.lastMessageDate?.toString();
    AppState appState = Provider.of<AppState>(context, listen: false);
    int myId = appState.authService.getId()!;
    User? member;
  
    if (room.name != null) {
      label = room.name ?? label;
    } else {
      EntityStore<User> userStore =
          Provider.of<EntityStore<User>>(context, listen: false);
      for (int memberId in room.members){
        if (memberId != myId){
          member = userStore.getEntity(memberId)!;
        }
      }
      label = member?.email ?? label;
    }
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    // ChatPageCopyWidget(),
                    RoomPageWidget(
                  room: room,
                ),
              ));
        },
        child: Container(
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
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                    child: Text(
                      label,
                      style: const TextStyle(
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
                    lastMessageDate ?? "",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF1D2429),
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget userListElement(User user, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x32000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.network(
                  'https://images.unsplash.com/photo-1518860308377-800f02d5498a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF57636C),
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        user.online ? "online" : "",
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF1D2429),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  width: 70,
                  height: 36,
                  margin: EdgeInsets.all(25),
                  // FFButtonWidget(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    child: Text("Чат"),
                    onPressed: () {
                      // RoomStore roomStore = Provider.of<RoomStore>(context, listen: false);
                      int? roomId = getOrCreateRoom(context, user.id);
                      print("room: $roomId for user: ${user.id}");
                      Navigator.pushNamed(context, '/');
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  int? getOrCreateRoom(BuildContext context, int? userId) {
    if (userId == null) {
      return -1;
    }
    RoomStore roomStorage = Provider.of<RoomStore>(context, listen: false);
    for (var i = 0; i < roomStorage.length; i++) {
      Room room = roomStorage.getEntityByIndex(i);
      if (room.containsMember(userId)) {
        return room.id;
      }
    }
    String resource = "room";
    String addFrinedCommandUid = "createRoom#$userId";
    String action = "create";
    Map<String, dynamic> payload = {
      "members_id": [userId],
      "private": true
    };
    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.socket.sendCommand(
        Command(resource, payload, action, uid: addFrinedCommandUid));
    return null;
  }

  // Widget requestListElement(User user) {
  //   return Padding(
  //     padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
  //     child: Container(
  //       width: double.infinity,
  //       height: 50,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //             blurRadius: 4,
  //             color: Color(0x32000000),
  //             offset: Offset(0, 2),
  //           )
  //         ],
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Padding(
  //         padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
  //         child: Row(
  //           mainAxisSize: MainAxisSize.max,
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(26),
  //               child: Image.network(
  //                 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
  //                 width: 36,
  //                 height: 36,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             Expanded(
  //               child: Padding(
  //                 padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.max,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "Some name #1",
  //                       style: TextStyle(
  //                         fontFamily: 'Outfit',
  //                         color: Color(0xFF1D2429),
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.normal,
  //                       ),
  //                     ),
  //                     Row(
  //                       mainAxisSize: MainAxisSize.max,
  //                       children: [
  //                         Text(
  //                           'user@domainname.com',
  //                           style: TextStyle(
  //                             fontFamily: 'Outfit',
  //                             color: Color(0xFF57636C),
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.normal,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Container(
  //                 width: 70,
  //                 height: 36,
  //                 margin: EdgeInsets.all(25),
  //                 // FFButtonWidget(
  //                 child: ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     primary: Colors.grey,
  //                   ),
  //                   child: Text("Chat"),
  //                   onPressed: () {},
  //                 )),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
