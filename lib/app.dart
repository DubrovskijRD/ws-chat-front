import 'package:flutter/material.dart';
import 'package:flutter_application_1/entity/base.dart';
import 'package:flutter_application_1/entity/chat.dart';
import 'package:flutter_application_1/entity/users.dart';
import 'package:flutter_application_1/pages/room_list_page.dart';
import 'package:flutter_application_1/pages/register_confirm_page.dart';
import 'package:flutter_application_1/pages/search_user_page.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter_application_1/services/websocket.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/pages/login_page.dart' as lp;

class EntityStore<E extends Entity> extends ChangeNotifier {
  final Map<int, E> _entityStore = {};

  void addEntity(E entity) {
    _entityStore[entity.id!] = entity;
    notifyListeners();
  }

  E? getEntity(int id) {
    return _entityStore[id];
  }

  E getEntityByIndex(int index) {
    int id = _entityStore.keys.elementAt(index);
    return _entityStore[id]!;
  }

  E popEntity(int id) {
    E entity = _entityStore.remove(id)!;
    notifyListeners();
    return entity;
  }

  int get length {
    return _entityStore.length;
  }

  Map<int, E> get entities {
    return _entityStore;
  }
}

class RoomStore extends EntityStore<Room> {
  
  void addMessage(Message message, int myId) {
    if (message.creatorId == myId) {
      message.own = true;
    }
    print("ADD message own - ${message.own} ($myId, ${message.creatorId}) :${message.body}, ");
    rooms[message.roomId]!.addMessage(message);
    notifyListeners();
  }

  Map<int, Room> get rooms => _entityStore;
}

class BaseFriendRequestStore extends ChangeNotifier {
  final Map<int, User> _requestStore = {};

  void addRequest(User user) {
    _requestStore[user.id!] = user;
    notifyListeners();
  }

  User getRequestByIndex(int index) {
    int id = _requestStore.keys.elementAt(index);
    return _requestStore[id]!;
  }

  User popEntity(int id) {
    User user = _requestStore.remove(id)!;
    notifyListeners();
    return user;
  }

  int get length {
    return _requestStore.length;
  }
}

class FriendRequestIncomingStore extends BaseFriendRequestStore {}

class FriendRequestOutgoingStore extends BaseFriendRequestStore {}

class QueryResponseMap extends ChangeNotifier {
  final Map<String, dynamic> queryResponseMap = {};

  dynamic get(String uid) {
    return queryResponseMap[uid];
  }

  void set(String uid, dynamic response) {
    queryResponseMap[uid] = response;
    notifyListeners();
  }

  dynamic pop(String uid) {
    dynamic response = queryResponseMap[uid];
    return response;
  }

  int get length {
    return queryResponseMap.length;
  }
}

class ConnectState extends ChangeNotifier {
  bool _conected = false;

  bool get conected {
    return _conected;
  }

  set conected(bool value) {
    _conected = value;
    if (!value){
      notifyListeners();
    }
    
  }
}

class AppState {
  final AuthService authService;

  EntityStore<User> userStore = EntityStore();
  late RoomStore roomStore;
  ConnectState connectState = ConnectState();

  FriendRequestIncomingStore incomingRequestStore =
      FriendRequestIncomingStore();
  FriendRequestOutgoingStore outgoingRequestStore =
      FriendRequestOutgoingStore();
  final QueryResponseMap queryResponseMap;
  late WebSocket socket;
  // final WebSocket socket = WebSocket(queryResponseMap);
  AppState(this.authService, this.queryResponseMap) {
    socket = WebSocket(queryResponseMap, connectState);
    roomStore = RoomStore();
    // connect();
  }

  connect() {
    if (connectState.conected){
      return;
    }
    String? token = authService.getToken();
    if (token != null) {
      socket.connect(token, socketListner);
    }
  }

  disconnect() {
    socket.close();
    connectState.conected = false;
  }

  void setAuth(String email, String token, int id) {
    authService.setAuth(email, token, id);
  }

  handleNewRoom(Room room) {
    roomStore.addEntity(room);
    socket.sendQuery(Query('message', {"room_id": room.id}));
  }

  socketListner(message) {
    dynamic queryData = message['query'];
    if (queryData != null) {
      // todo refactor
      if (queryData['resource'] == 'user') {
        queryResponseMap.set(
            queryData['uid'],
            message['response']
                .map((userData) => User.fromJson(userData))
                .toList());
      } else if (queryData['resource'] == 'friend') {
        message['response'].forEach(
            (userData) => {userStore.addEntity(User.fromJson(userData))});
      } else if (queryData['resource'] == 'friend_request') {       
        message['response']['incoming'].forEach((userData) =>
            {incomingRequestStore.addRequest(User.fromJson(userData))});
        message['response']['outgoing'].forEach((userData) =>
            {outgoingRequestStore.addRequest(User.fromJson(userData))});
        print(incomingRequestStore.length);
        print(outgoingRequestStore.length);
      } else if (queryData['resource'] == 'room') {
        message['response']
            .forEach((roomData) => {handleNewRoom(Room.fromJson(roomData))});
      } else if (queryData['resource'] == 'message') {
        message['response'].forEach((messageData) =>
            {roomStore.addMessage(Message.fromJson(messageData), authService.getId()!)});
      }
    }
    dynamic commandData = message['command'];
    // {
    //   "command": {
    //     "uid": "-",
    //     "action": "CommandAction.UPDATE",
    //     "payload": {
    //       "online": true,
    //       "id": 1
    //     },
    //     "resource": "friends"
    //   },
    //   "user_id": 1,
    //   "result": {}
    // }
    if (commandData != null) {
      String resource = commandData['resource'];
      if (resource == 'message') {
        message['result'].forEach((messageData) =>
            {roomStore.addMessage(Message.fromJson(messageData), authService.getId()!)});
      }
      // else if (resource == 'message'){}
    }
  }
}

class ChatApp extends StatefulWidget {
  late AppState appState;
  ChatApp(AuthService authService, {Key? key}) : super(key: key) {
    appState = AppState(authService, QueryResponseMap());
  }

  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AppState>(
            create: (_) => widget.appState,
          ),
          ChangeNotifierProvider<ConnectState>(
              create: (context) => widget.appState.connectState),
          ChangeNotifierProvider<EntityStore<User>>(
              create: (context) => widget.appState.userStore),
          ChangeNotifierProvider<RoomStore>(
              create: (context) => widget.appState.roomStore),
          ChangeNotifierProvider<QueryResponseMap>(
              create: (context) => widget.appState.queryResponseMap),
          ChangeNotifierProvider<FriendRequestIncomingStore>(
              create: (context) => widget.appState.incomingRequestStore),
          ChangeNotifierProvider<FriendRequestOutgoingStore>(
              create: (context) => widget.appState.outgoingRequestStore),
        ],
        child: Consumer<ConnectState>(builder: (context, connectState, child) {
          widget.appState.connect();
          return _App(widget.appState, connectState);
        }));
  }
}

class _App extends StatefulWidget {
  late AppState appState;
  late ConnectState connectState;
  _App(this.appState, this.connectState);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> {

  // @override
  // void initState() {
  //   print("!!! - INIT");
  //   if (!widget.connectState.conected){
  //     _connect();
  //   }
  //   super.initState();
    
  // }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: widget.appState.authService.isLogin() ? '/' : '/login',
      routes: {
        '/': (context) => RoomListPageWidget(),
        '/login': (context) => lp.LoginPageWidget(),
        '/register/confirm': (context) => ConfirmRegisterPageWidget(),
        '/users/search': (context) => SearchUsersWidget(),
        // '/room_list_page':(context) => RoomListPageWidget(),
      },
      // onGenerateRoute: (settings) {
      //   if (settings.name == RoomPage.routeName) {
      //     print(settings.arguments);
      //     if (settings.arguments != null) {
      //       final args = settings.arguments as RoomPageArgument;
      //       print(args.roomId);
      //       return MaterialPageRoute(builder: (context) {
      //         return RoomPage(roomId: args.roomId);
      //       });
      //     }
      //   }
      //   return MaterialPageRoute(builder: (context) {
      //     return HomePage();
      //   });
      // },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
      ),
    );
  }

  _connect() {
    print("[!!] reconnect");
    widget.appState.connect();
  }
}
