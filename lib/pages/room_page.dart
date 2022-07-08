import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/entity/chat.dart';
import 'package:flutter_application_1/entity/users.dart';
import 'package:flutter_application_1/services/websocket.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RoomPageWidget extends StatefulWidget {
  late Room room;
  RoomPageWidget({Key? key, required Room this.room}) : super(key: key);

  @override
  _RoomPageWidgetState createState() => _RoomPageWidgetState();
}

class _RoomPageWidgetState extends State<RoomPageWidget> {
  late TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    String label = "???";
    AppState appState = Provider.of<AppState>(context, listen: false);
    int myId = appState.authService.getId()!;
    User? member;
  
    if (widget.room.name != null) {
      label = widget.room.name ?? label;
    } else {
      EntityStore<User> userStore =
          Provider.of<EntityStore<User>>(context, listen: false);
      for (int memberId in widget.room.members){
        if (memberId != myId){
          member = userStore.getEntity(memberId)!;
        }
      }
      label = member?.email ?? label;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Theme.of(context).primaryColorLight,
                      offset: Offset(0, 4),
                    )
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1485981133625-f1a03c887f0a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: Consumer<RoomStore>(
                builder: (context, roomStore, child) {
                  Room room =
                      roomStore.getEntity(widget.room.id!)!;
                  return ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: room.messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        Message message = List.from(room.messages.reversed)[index];
                        return messageWidget(message);
                      });
                },
              )),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 4, 8, 0),
                        child: TextFormField(
                          controller: textController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            labelStyle: TextStyle(
                              fontFamily: 'Open Sans',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF1F4F8),
                          ),
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            color: Color(0xFF1D2429),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 16, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // borderColor: Colors.transparent,
                          // borderRadius: 30,
                          // borderWidth: 1,
                          // buttonSize: 40,
                          primary: Color(0xFF4B39EF),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          print('IconButton pressed ...');
                          sendMessage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageWidget(Message message) {

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: message.own ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 227, 232, 253),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Color.fromARGB(255, 86, 114, 206),
                    offset: Offset(2, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                child: Text(
                  message.body,
                  style: const TextStyle(
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

    void sendMessage() {
    String body = textController.text;
    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.socket.sendCommand(Command("message", {"room_id": widget.room.id, "msg_type": 1, "msg_body": body}, "create"));
    textController.clear();
  }
}
