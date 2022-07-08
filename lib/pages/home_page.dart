// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/app.dart';
// import 'package:flutter_application_1/entity/chat.dart';
// import 'package:flutter_application_1/entity/users.dart';
// import 'package:flutter_application_1/pages/room_page.dart';
// import 'package:flutter_application_1/services/websocket.dart';
// import 'package:flutter_application_1/widgets/room.dart';
// import 'package:flutter_application_1/widgets/user.dart';
// import 'dart:math';
// import 'package:provider/provider.dart';

// const String searchStateName = 'search';
// const String roomStateName = 'rooms';
// const String friendStateName = 'frineds';



// class HomePageArgument {
//   String? initView;
//   HomePageArgument({this.initView});
// }

// class HomePage extends StatefulWidget {
//   HomePageArgument? args;
//   HomePage({Key? key, this.args}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String _currentView = roomStateName;

//   @override
//   void initState() {
//     super.initState();
//     AppState appState = Provider.of<AppState>(context, listen: false);
//     Future(() {
//       if (!appState.authService.isLogin()) {
//         Navigator.pushNamed(context, '/login');
//       }
//       appState.socket.sendQuery(Query('friend', {}, uid: "fq"));
//       appState.socket.sendQuery(Query('room', {}, uid: "rq"));
//       appState.socket.sendQuery(Query('friend_request', {"incoming":true,"outgoing":true}));
//       // in this momet roomStore is empty
//       // for (final room in appState.roomStore.rooms){
//       //     appState.socket.sendQuery(Query('message', {"room_id": room.id}));
//       // }

//       Navigator.pushNamed(context, '/room_page_list');

//         setCurrentVeiw(widget.args?.initView ?? _currentView);

      
//     });
//   }

//   void setCurrentVeiw(String name) {
//     setState(() {
//       _currentView = name;
//     });
//   }

  

//   Widget friendIncomingRequestsList() {
//     return Consumer<FriendRequestIncomingStore>(
//       builder: (context, requestStore, child) {
//         return ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: requestStore.length,
//             itemBuilder: (BuildContext context, int index) {
//               return UserWidget(requestStore.getRequestByIndex(index), needStartChating: false,);
//             });
//       },
//     );
//   }

//   Widget friendOutgoingRequestsList() {
//     return Consumer<FriendRequestIncomingStore>(
//       builder: (context, requestStore, child) {
//         return ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: requestStore.length,
//             itemBuilder: (BuildContext context, int index) {
//               return UserWidget(requestStore.getRequestByIndex(index));
//             });
//       },
//     );
//   }

//   Widget friendsList() {
//     return Consumer<EntityStore<User>>(
//       builder: (context, userStore, child) {
//         print(userStore.length);
//         return ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: userStore.length,
//             itemBuilder: (BuildContext context, int index) {
//               return UserWidget(userStore.getEntityByIndex(index), needStartChating: true,);
//             });
//       },
//     );
//   }

//   Widget roomList() {
//     return Consumer<RoomStore>(
//       builder: (context, roomStore, child) {
//         return ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: roomStore.length,
//             itemBuilder: (BuildContext context, int index) {
//               Room room = roomStore.getEntityByIndex(index);
//               return ElevatedButton(
//   onPressed: () {
//     Navigator.pushNamed(
//       context,
//       RoomPage.routeName,
//       arguments: RoomPageArgument(room.id!),
//     );
//   },
//   child: 
//   // RoomWidget(room)
//   Text("[!] Room widget")
//   ,);
//             });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // if (!authService.isLogin()) {
//     //   Navigator.pushNamed(context, '/login');
//     // }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("-"), // websocket status
//       ),
//       body: Center(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//             Text("$_currentView:"),
//             currentView(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextButton(
//                     onPressed: () {
//                       setCurrentVeiw(searchStateName);
//                       // AppState appState =
//                       //     Provider.of<AppState>(context, listen: false);
//                       // appState.socket.send(WsMessage("ping", "get", {}));

//                       // userStore.addEntity(User(
//                       //     Random().nextInt(1000), "User${Random().nextInt(1000)}"));
//                     },
//                     child: Text("search")),
//                 TextButton(
//                     onPressed: () {
//                       setCurrentVeiw(roomStateName);
//                     },
//                     child: Text("Chats")),
//                 TextButton(
//                     onPressed: () {
//                       setCurrentVeiw(friendStateName);
//                     },
//                     child: Text("Friends")),
//               ],
//             )
//           ])),
//     );
//   }

//   Widget currentView() {
//     if (_currentView == roomStateName) {
//       return Expanded(child: roomList());
//     }
//     if (_currentView == friendStateName) {
//       return Expanded(child: friendsList());
//     }
//     return SearchView();
//   }
// }

// class SearchView extends StatefulWidget {
//   @override
//   _SearchViewState createState() => _SearchViewState();
// }

// class _SearchViewState extends State<SearchView> {
//   String? searchQuery;
//   String searchQueryUid = '-';
//   TextEditingController controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: Column(
//       children: [
//         searchFieldWidget(),
//         userList(),
//       ],
//     ));
//   }

//   Widget searchFieldWidget() {
//     return Row(children: [
//       Expanded(
//         child: TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             border: OutlineInputBorder(),
//             labelText: 'Search',
//           ),
//         ),
//       ),
//       TextButton.icon(
//         onPressed: search,
//         icon: Icon(Icons.search),
//         label: Text("Search"),
//       )
//     ]);
//   }

//   Widget userList() {
//     AppState appState = Provider.of<AppState>(context, listen: false);
//     String email = appState.authService.getEmail()!;
//     return Consumer<QueryResponseMap>(
//         builder: (context, queryResponseMap, child) {
//       print("$searchQuery, ${queryResponseMap.get(searchQueryUid)?.length}");
//       // return Text("not found");
//       return [0, null].contains(queryResponseMap.get(searchQueryUid)?.length)
//           ? Text("not found with name $searchQuery")
//           : Expanded(
//               child: ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: queryResponseMap.get(searchQueryUid).length,
//                   itemBuilder: (BuildContext context, int index) {
//                     User user = queryResponseMap.get(searchQueryUid)?[index];
//                     void Function()? onPressAction = null;
//                     if (user.email != email){
//                         onPressAction = () => {addFriend(user)};
//                     }
//                     return Row(children: [
//                       UserWidget(user, isFrined: false,),
//                       TextButton(
//                           onPressed: onPressAction,
//                           child: Text("+"))
//                     ]);
//                     // return Text(
//                     //   "Users - ${queryResponseMap.get(searchQueryUid)}",
//                     //   style: TextStyle(fontSize: 22),
//                     // );
//                   }));
//     });
//   }

//   void search() {
//     AppState appState = Provider.of<AppState>(context, listen: false);
//     String resource = "user";
//     Map<String, dynamic> payload = {"q": controller.text};
//     setState(() {
//       searchQueryUid = "searchQuery#${Random().nextInt(1000)}";
//       searchQuery = controller.text;
//     });
//     appState.socket.sendQuery(Query(resource, payload, uid: searchQueryUid));
//   }

//   void addFriend(User user) {
//     AppState appState = Provider.of<AppState>(context, listen: false);
//     String resource = "friend";
//     String addFrinedCommandUid = "addFrined#${user.id}";
//     String action = "create";
//     Map<String, dynamic> payload = {"user_id": user.id};

//     appState.socket
//         .sendCommand(Command(resource, payload, action, uid: addFrinedCommandUid));
//   }
      
// }
