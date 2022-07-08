import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/entity/users.dart';
import 'package:flutter_application_1/services/websocket.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchUsersWidget extends StatefulWidget {
  const SearchUsersWidget({Key? key}) : super(key: key);

  @override
  _SearchUsersWidgetState createState() => _SearchUsersWidgetState();
}

class _SearchUsersWidgetState extends State<SearchUsersWidget> {
  late TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String searchQueryUid = "-";
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        // backgroundColor: Color(0xFFF1F4F8),
        // automaticallyImplyLeading: false,
        // leading: FlutterFlowIconButton(
        //   borderColor: Colors.transparent,
        //   borderRadius: 30,
        //   borderWidth: 1,
        //   buttonSize: 54,
        //   icon: Icon(
        //     Icons.arrow_back_rounded,
        //     color: Color(0xFF57636C),
        //     size: 24,
        //   ),
        //   onPressed: () async {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Text(
          'Add Members',
          style: TextStyle(
            fontFamily: 'Outfit',
            color: Color(0xFF1D2429),
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF1F4F8),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      // labelStyle: Theme.of(context).bodyText1,
                      indicatorColor: Theme.of(context).secondaryHeaderColor,
                      tabs: [
                        Tab(
                          text: 'Поиск',
                        ),
                        Tab(
                          text: 'Входящие',
                        ),
                        Tab(
                          text: 'Исходящие',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    16, 8, 16, 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: textController,
                                        onChanged: (_) => EasyDebounce.debounce(
                                          'textController',
                                          Duration(milliseconds: 2000),
                                          () => setState(() {}),
                                        ),
                                        autofocus: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Search users...',
                                          labelStyle: TextStyle(
                                            fontFamily: 'Outfit',
                                            color: Color(0xFF57636C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          color: Color(0xFF1D2429),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 0, 0, 0),
                                      child: Container(
                                        child: ElevatedButton(
                                          child: Icon(
                                            Icons.search_rounded,
                                            color: Color(0xFF1D2429),
                                            size: 24,
                                          ),
                                          style: ElevatedButton.styleFrom(),
                                          onPressed: () {
                                            search();
                                          },
                                        ),
                                      ),
                                      // FlutterFlowIconButton(
                                      //   borderColor: Colors.transparent,
                                      //   borderRadius: 30,
                                      //   borderWidth: 1,
                                      //   buttonSize: 44,
                                      //   icon: Icon(
                                      //     Icons.search_rounded,
                                      //     color: Color(0xFF1D2429),
                                      //     size: 24,
                                      //   ),
                                      //   onPressed: () {
                                      //     print('IconButton pressed ...');
                                      //   },
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 44),
                                  child: Consumer<QueryResponseMap>(builder:
                                      (context, queryResponseMap, child) {
                                    dynamic queryResponse =
                                        queryResponseMap.get(searchQueryUid);
                                    if ([0, null].contains(queryResponseMap.get(searchQueryUid)?.length)) {
                                      String searchQueryFormatted = (searchQuery != null) ? searchQuery! : '';
                                      return Text("По запросу '$searchQueryFormatted' ничего не найдено", style: TextStyle(color: Colors.grey),);
                                    }
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(8),
                                        itemCount: queryResponse.length,
                                        itemBuilder: (context, index) {
                                          return searchListElement(
                                              queryResponse[index]);
                                        });
                                  })),
                            ],
                          ),
                          // Column(
                          //   mainAxisSize: MainAxisSize.max,
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsetsDirectional.fromSTEB(
                          //           0, 12, 0, 44),
                          //       child: ListView(
                          //         padding: EdgeInsets.zero,
                          //         primary: false,
                          //         shrinkWrap: true,
                          //         scrollDirection: Axis.vertical,
                          //         children: [
                          //           Padding(
                          //             padding: EdgeInsetsDirectional.fromSTEB(
                          //                 16, 4, 16, 8),
                          //             child: Container(
                          //               width: double.infinity,
                          //               height: 50,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 boxShadow: [
                          //                   BoxShadow(
                          //                     blurRadius: 4,
                          //                     color: Color(0x32000000),
                          //                     offset: Offset(0, 2),
                          //                   )
                          //                 ],
                          //                 borderRadius:
                          //                     BorderRadius.circular(8),
                          //               ),
                          //               child: Padding(
                          //                 padding:
                          //                     EdgeInsetsDirectional.fromSTEB(
                          //                         8, 0, 8, 0),
                          //                 child: Row(
                          //                   mainAxisSize: MainAxisSize.max,
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     ClipRRect(
                          //                       borderRadius:
                          //                           BorderRadius.circular(26),
                          //                       child: Image.network(
                          //                         'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                          //                         width: 36,
                          //                         height: 36,
                          //                         fit: BoxFit.cover,
                          //                       ),
                          //                     ),
                          //                     Expanded(
                          //                       child: Padding(
                          //                         padding: EdgeInsetsDirectional
                          //                             .fromSTEB(12, 0, 0, 0),
                          //                         child: Column(
                          //                           mainAxisSize:
                          //                               MainAxisSize.max,
                          //                           mainAxisAlignment:
                          //                               MainAxisAlignment
                          //                                   .center,
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment
                          //                                   .start,
                          //                           children: [
                          //                             Text(
                          //                               "random name 4",
                          //                               style: TextStyle(
                          //                                 fontFamily: 'Outfit',
                          //                                 color:
                          //                                     Color(0xFF1D2429),
                          //                                 fontSize: 14,
                          //                                 fontWeight:
                          //                                     FontWeight.normal,
                          //                               ),
                          //                             ),
                          //                             Row(
                          //                               mainAxisSize:
                          //                                   MainAxisSize.max,
                          //                               children: [
                          //                                 Text(
                          //                                   'user@domainname.com',
                          //                                   style: TextStyle(
                          //                                     fontFamily:
                          //                                         'Outfit',
                          //                                     color: Color(
                          //                                         0xFF57636C),
                          //                                     fontSize: 14,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .normal,
                          //                                   ),
                          //                                 ),
                          //                               ],
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     Container(
                          //                       width: 70,
                          //                       height: 36,
                          //                       margin: EdgeInsets.all(25),
                          //                       child: ElevatedButton(
                          //                         child: Text(
                          //                           "add",
                          //                           style: TextStyle(
                          //                             fontFamily: 'Outfit',
                          //                             color: Colors.white,
                          //                             fontSize: 14,
                          //                             fontWeight:
                          //                                 FontWeight.normal,
                          //                           ),
                          //                         ),
                          //                         style: ElevatedButton
                          //                             .styleFrom(),
                          //                         onPressed: () {
                          //                           print('Button pressed ...');
                          //                         },
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           Padding(
                          //             padding: EdgeInsetsDirectional.fromSTEB(
                          //                 16, 4, 16, 8),
                          //             child: Container(
                          //               width: double.infinity,
                          //               height: 50,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 boxShadow: [
                          //                   BoxShadow(
                          //                     blurRadius: 4,
                          //                     color: Color(0x32000000),
                          //                     offset: Offset(0, 2),
                          //                   )
                          //                 ],
                          //                 borderRadius:
                          //                     BorderRadius.circular(8),
                          //               ),
                          //               child: Padding(
                          //                 padding:
                          //                     EdgeInsetsDirectional.fromSTEB(
                          //                         8, 0, 8, 0),
                          //                 child: Row(
                          //                   mainAxisSize: MainAxisSize.max,
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     ClipRRect(
                          //                       borderRadius:
                          //                           BorderRadius.circular(26),
                          //                       child: Image.network(
                          //                         'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                          //                         width: 36,
                          //                         height: 36,
                          //                         fit: BoxFit.cover,
                          //                       ),
                          //                     ),
                          //                     Expanded(
                          //                       child: Padding(
                          //                         padding: EdgeInsetsDirectional
                          //                             .fromSTEB(12, 0, 0, 0),
                          //                         child: Column(
                          //                           mainAxisSize:
                          //                               MainAxisSize.max,
                          //                           mainAxisAlignment:
                          //                               MainAxisAlignment
                          //                                   .center,
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment
                          //                                   .start,
                          //                           children: [
                          //                             Text(
                          //                               "random name 4",
                          //                               style: TextStyle(
                          //                                 fontFamily: 'Outfit',
                          //                                 color:
                          //                                     Color(0xFF1D2429),
                          //                                 fontSize: 14,
                          //                                 fontWeight:
                          //                                     FontWeight.normal,
                          //                               ),
                          //                             ),
                          //                             Row(
                          //                               mainAxisSize:
                          //                                   MainAxisSize.max,
                          //                               children: [
                          //                                 Text(
                          //                                   'user@domainname.com',
                          //                                   style: TextStyle(
                          //                                     fontFamily:
                          //                                         'Outfit',
                          //                                     color: Color(
                          //                                         0xFF57636C),
                          //                                     fontSize: 14,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .normal,
                          //                                   ),
                          //                                 ),
                          //                               ],
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     Container(
                          //                       width: 70,
                          //                       height: 36,
                          //                       margin: EdgeInsets.all(25),
                          //                       child: ElevatedButton(
                          //                         child: Text(
                          //                           "add",
                          //                           style: TextStyle(
                          //                             fontFamily: 'Outfit',
                          //                             color: Colors.white,
                          //                             fontSize: 14,
                          //                             fontWeight:
                          //                                 FontWeight.normal,
                          //                           ),
                          //                         ),
                          //                         style: ElevatedButton
                          //                             .styleFrom(),
                          //                         onPressed: () {
                          //                           print('Button pressed ...');
                          //                         },
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           Padding(
                          //             padding: EdgeInsetsDirectional.fromSTEB(
                          //                 16, 4, 16, 8),
                          //             child: Container(
                          //               width: double.infinity,
                          //               height: 50,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 boxShadow: [
                          //                   BoxShadow(
                          //                     blurRadius: 4,
                          //                     color: Color(0x32000000),
                          //                     offset: Offset(0, 2),
                          //                   )
                          //                 ],
                          //                 borderRadius:
                          //                     BorderRadius.circular(8),
                          //               ),
                          //               child: Padding(
                          //                 padding:
                          //                     EdgeInsetsDirectional.fromSTEB(
                          //                         8, 0, 8, 0),
                          //                 child: Row(
                          //                   mainAxisSize: MainAxisSize.max,
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     ClipRRect(
                          //                       borderRadius:
                          //                           BorderRadius.circular(26),
                          //                       child: Image.network(
                          //                         'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                          //                         width: 36,
                          //                         height: 36,
                          //                         fit: BoxFit.cover,
                          //                       ),
                          //                     ),
                          //                     Expanded(
                          //                       child: Padding(
                          //                         padding: EdgeInsetsDirectional
                          //                             .fromSTEB(12, 0, 0, 0),
                          //                         child: Column(
                          //                           mainAxisSize:
                          //                               MainAxisSize.max,
                          //                           mainAxisAlignment:
                          //                               MainAxisAlignment
                          //                                   .center,
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment
                          //                                   .start,
                          //                           children: [
                          //                             Text(
                          //                               'Username',
                          //                               style: TextStyle(
                          //                                 fontFamily: 'Outfit',
                          //                                 color:
                          //                                     Color(0xFF1D2429),
                          //                                 fontSize: 14,
                          //                                 fontWeight:
                          //                                     FontWeight.normal,
                          //                               ),
                          //                             ),
                          //                             Row(
                          //                               mainAxisSize:
                          //                                   MainAxisSize.max,
                          //                               children: [
                          //                                 Text(
                          //                                   'user@domainname.com',
                          //                                   style: TextStyle(
                          //                                     fontFamily:
                          //                                         'Outfit',
                          //                                     color: Color(
                          //                                         0xFF57636C),
                          //                                     fontSize: 14,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .normal,
                          //                                   ),
                          //                                 ),
                          //                               ],
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     Container(
                          //                       width: 70,
                          //                       height: 36,
                          //                       margin: EdgeInsets.all(25),
                          //                       child: ElevatedButton(
                          //                         child: Text(
                          //                           "add",
                          //                           style: TextStyle(
                          //                             fontFamily: 'Outfit',
                          //                             color: Colors.white,
                          //                             fontSize: 14,
                          //                             fontWeight:
                          //                                 FontWeight.normal,
                          //                           ),
                          //                         ),
                          //                         style: ElevatedButton
                          //                             .styleFrom(),
                          //                         onPressed: () {
                          //                           print('Button pressed ...');
                          //                         },
                          //                       ),
                          //                     ),
                          //                     // FFButtonWidget(
                          //                     //   onPressed: () {
                          //                     //     print('Button pressed ...');
                          //                     //   },
                          //                     //   text: 'Add',
                          //                     //   options: FFButtonOptions(
                          //                     //     width: 70,
                          //                     //     height: 36,
                          //                     //     color: Color(0xFF4B39EF),
                          //                     //     textStyle: TextStyle(
                          //                     //       fontFamily: 'Outfit',
                          //                     //       color: Colors.white,
                          //                     //       fontSize: 14,
                          //                     //       fontWeight:
                          //                     //           FontWeight.normal,
                          //                     //     ),
                          //                     //     borderSide: BorderSide(
                          //                     //       color: Colors.transparent,
                          //                     //       width: 1,
                          //                     //     ),
                          //                     //     borderRadius: 8,
                          //                     //   ),
                          //                     // ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           Padding(
                          //             padding: EdgeInsetsDirectional.fromSTEB(
                          //                 16, 4, 16, 8),
                          //             child: Container(
                          //               width: double.infinity,
                          //               height: 50,
                          //               decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 boxShadow: [
                          //                   BoxShadow(
                          //                     blurRadius: 4,
                          //                     color: Color(0x32000000),
                          //                     offset: Offset(0, 2),
                          //                   )
                          //                 ],
                          //                 borderRadius:
                          //                     BorderRadius.circular(8),
                          //               ),
                          //               child: Padding(
                          //                 padding:
                          //                     EdgeInsetsDirectional.fromSTEB(
                          //                         8, 0, 8, 0),
                          //                 child: Row(
                          //                   mainAxisSize: MainAxisSize.max,
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment.spaceBetween,
                          //                   children: [
                          //                     ClipRRect(
                          //                       borderRadius:
                          //                           BorderRadius.circular(26),
                          //                       child: Image.network(
                          //                         'https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzJ8fHVzZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                          //                         width: 36,
                          //                         height: 36,
                          //                         fit: BoxFit.cover,
                          //                       ),
                          //                     ),
                          //                     Expanded(
                          //                       child: Padding(
                          //                         padding: EdgeInsetsDirectional
                          //                             .fromSTEB(12, 0, 0, 0),
                          //                         child: Column(
                          //                           mainAxisSize:
                          //                               MainAxisSize.max,
                          //                           mainAxisAlignment:
                          //                               MainAxisAlignment
                          //                                   .center,
                          //                           crossAxisAlignment:
                          //                               CrossAxisAlignment
                          //                                   .start,
                          //                           children: [
                          //                             Text(
                          //                               "random name 5",
                          //                               style: TextStyle(
                          //                                 fontFamily: 'Outfit',
                          //                                 color:
                          //                                     Color(0xFF1D2429),
                          //                                 fontSize: 14,
                          //                                 fontWeight:
                          //                                     FontWeight.normal,
                          //                               ),
                          //                             ),
                          //                             Row(
                          //                               mainAxisSize:
                          //                                   MainAxisSize.max,
                          //                               children: [
                          //                                 Text(
                          //                                   'user@domainname.com',
                          //                                   style: TextStyle(
                          //                                     fontFamily:
                          //                                         'Outfit',
                          //                                     color: Color(
                          //                                         0xFF57636C),
                          //                                     fontSize: 14,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .normal,
                          //                                   ),
                          //                                 ),
                          //                               ],
                          //                             ),
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     ),
                          //                     Container(
                          //                       width: 70,
                          //                       height: 36,
                          //                       margin: EdgeInsets.all(25),
                          //                       child: ElevatedButton(
                          //                         child: Text(
                          //                           "add",
                          //                           style: TextStyle(
                          //                             fontFamily: 'Outfit',
                          //                             color: Colors.white,
                          //                             fontSize: 14,
                          //                             fontWeight:
                          //                                 FontWeight.normal,
                          //                           ),
                          //                         ),
                          //                         style: ElevatedButton
                          //                             .styleFrom(),
                          //                         onPressed: () {
                          //                           print('Button pressed ...');
                          //                         },
                          //                       ),
                          //                     ),
                          //                     // FFButtonWidget(
                          //                     //   onPressed: () {
                          //                     //     print('Button pressed ...');
                          //                     //   },
                          //                     //   text: 'Add',
                          //                     //   options: FFButtonOptions(
                          //                     //     width: 70,
                          //                     //     height: 36,
                          //                     //     color: Color(0xFF4B39EF),
                          //                     //     textStyle: TextStyle(
                          //                     //           fontFamily: 'Outfit',
                          //                     //           color: Colors.white,
                          //                     //           fontSize: 14,
                          //                     //           fontWeight:
                          //                     //               FontWeight.normal,
                          //                     //         ),
                          //                     //     borderSide: BorderSide(
                          //                     //       color: Colors.transparent,
                          //                     //       width: 1,
                          //                     //     ),
                          //                     //     borderRadius: 8,
                          //                     //   ),
                          //                     // ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 12, 0, 12),
                                  child: Consumer<FriendRequestIncomingStore>(
                                      builder: (context, requestStore, child) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(8),
                                        itemCount: requestStore.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          User user = requestStore
                                              .getRequestByIndex(index);
                                          return requestListElement(user, true);
                                        });
                                  }),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 12, 0, 44),
                                    child: 
                                    Consumer<FriendRequestOutgoingStore>(
                                      builder: (context, requestStore, child) {
                                        print(requestStore);
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.all(8),
                                        itemCount: requestStore.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          User user = requestStore
                                              .getRequestByIndex(index);
                                          return requestListElement(user, false);
                                        });
                                  }),
                                    // ListView.builder(
                                    //     shrinkWrap: true,
                                    //     padding: const EdgeInsets.all(8),
                                    //     // itemCount: requestStore.length,
                                    //     itemCount: 3,
                                    //     itemBuilder:
                                    //         (BuildContext context, int index) {
                                    //       // User user = requestStore
                                    //       //     .getRequestByIndex(index);
                                    //       return Text("Входящий запрос");
                                    //     })



                                    // ___________________
                                    // ListView(
                                    //   padding: EdgeInsets.zero,
                                    //   primary: false,
                                    //   shrinkWrap: true,
                                    //   scrollDirection: Axis.vertical,
                                    //   children: [
                                    //     Padding(
                                    //       padding: EdgeInsetsDirectional.fromSTEB(
                                    //           16, 4, 16, 8),
                                    //       child: Container(
                                    //         width: double.infinity,
                                    //         height: 50,
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.white,
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               blurRadius: 4,
                                    //               color: Color(0x32000000),
                                    //               offset: Offset(0, 2),
                                    //             )
                                    //           ],
                                    //           borderRadius:
                                    //               BorderRadius.circular(8),
                                    //         ),
                                    //         child: Padding(
                                    //           padding:
                                    //               EdgeInsetsDirectional.fromSTEB(
                                    //                   8, 0, 8, 0),
                                    //           child: Row(
                                    //             mainAxisSize: MainAxisSize.max,
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment.spaceBetween,
                                    //             children: [
                                    //               ClipRRect(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(26),
                                    //                 child: Image.network(
                                    //                   'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                                    //                   width: 36,
                                    //                   height: 36,
                                    //                   fit: BoxFit.cover,
                                    //                 ),
                                    //               ),
                                    //               Expanded(
                                    //                 child: Padding(
                                    //                   padding: EdgeInsetsDirectional
                                    //                       .fromSTEB(12, 0, 0, 0),
                                    //                   child: Column(
                                    //                     mainAxisSize:
                                    //                         MainAxisSize.max,
                                    //                     mainAxisAlignment:
                                    //                         MainAxisAlignment
                                    //                             .center,
                                    //                     crossAxisAlignment:
                                    //                         CrossAxisAlignment
                                    //                             .start,
                                    //                     children: [
                                    //                       Text(
                                    //                         "random name 6",
                                    //                         style: TextStyle(
                                    //                           fontFamily: 'Outfit',
                                    //                           color:
                                    //                               Color(0xFF1D2429),
                                    //                           fontSize: 14,
                                    //                           fontWeight:
                                    //                               FontWeight.normal,
                                    //                         ),
                                    //                       ),
                                    //                       Row(
                                    //                         mainAxisSize:
                                    //                             MainAxisSize.max,
                                    //                         children: [
                                    //                           Text(
                                    //                             'user@domainname.com',
                                    //                             style: TextStyle(
                                    //                               fontFamily:
                                    //                                   'Outfit',
                                    //                               color: Color(
                                    //                                   0xFF57636C),
                                    //                               fontSize: 14,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .normal,
                                    //                             ),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Padding(
                                    //       padding: EdgeInsetsDirectional.fromSTEB(
                                    //           16, 4, 16, 8),
                                    //       child: Container(
                                    //         width: double.infinity,
                                    //         height: 50,
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.white,
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               blurRadius: 4,
                                    //               color: Color(0x32000000),
                                    //               offset: Offset(0, 2),
                                    //             )
                                    //           ],
                                    //           borderRadius:
                                    //               BorderRadius.circular(8),
                                    //         ),
                                    //         child: Padding(
                                    //           padding:
                                    //               EdgeInsetsDirectional.fromSTEB(
                                    //                   8, 0, 8, 0),
                                    //           child: Row(
                                    //             mainAxisSize: MainAxisSize.max,
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment.spaceBetween,
                                    //             children: [
                                    //               ClipRRect(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(26),
                                    //                 child: Image.network(
                                    //                   'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTZ8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                                    //                   width: 36,
                                    //                   height: 36,
                                    //                   fit: BoxFit.cover,
                                    //                 ),
                                    //               ),
                                    //               Expanded(
                                    //                 child: Padding(
                                    //                   padding: EdgeInsetsDirectional
                                    //                       .fromSTEB(12, 0, 0, 0),
                                    //                   child: Column(
                                    //                     mainAxisSize:
                                    //                         MainAxisSize.max,
                                    //                     mainAxisAlignment:
                                    //                         MainAxisAlignment
                                    //                             .center,
                                    //                     crossAxisAlignment:
                                    //                         CrossAxisAlignment
                                    //                             .start,
                                    //                     children: [
                                    //                       Text(
                                    //                         "random name ?1",
                                    //                         style: TextStyle(
                                    //                           fontFamily: 'Outfit',
                                    //                           color:
                                    //                               Color(0xFF1D2429),
                                    //                           fontSize: 14,
                                    //                           fontWeight:
                                    //                               FontWeight.normal,
                                    //                         ),
                                    //                       ),
                                    //                       Row(
                                    //                         mainAxisSize:
                                    //                             MainAxisSize.max,
                                    //                         children: [
                                    //                           Text(
                                    //                             'user@domainname.com',
                                    //                             style: TextStyle(
                                    //                               fontFamily:
                                    //                                   'Outfit',
                                    //                               color: Color(
                                    //                                   0xFF57636C),
                                    //                               fontSize: 14,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .normal,
                                    //                             ),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Padding(
                                    //       padding: EdgeInsetsDirectional.fromSTEB(
                                    //           16, 4, 16, 8),
                                    //       child: Container(
                                    //         width: double.infinity,
                                    //         height: 50,
                                    //         decoration: BoxDecoration(
                                    //           color: Colors.white,
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               blurRadius: 4,
                                    //               color: Color(0x32000000),
                                    //               offset: Offset(0, 2),
                                    //             )
                                    //           ],
                                    //           borderRadius:
                                    //               BorderRadius.circular(8),
                                    //         ),
                                    //         child: Padding(
                                    //           padding:
                                    //               EdgeInsetsDirectional.fromSTEB(
                                    //                   8, 0, 8, 0),
                                    //           child: Row(
                                    //             mainAxisSize: MainAxisSize.max,
                                    //             mainAxisAlignment:
                                    //                 MainAxisAlignment.spaceBetween,
                                    //             children: [
                                    //               ClipRRect(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(26),
                                    //                 child: Image.network(
                                    //                   'https://images.unsplash.com/photo-1534528741775-53994a69daeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                                    //                   width: 36,
                                    //                   height: 36,
                                    //                   fit: BoxFit.cover,
                                    //                 ),
                                    //               ),
                                    //               Expanded(
                                    //                 child: Padding(
                                    //                   padding: EdgeInsetsDirectional
                                    //                       .fromSTEB(12, 0, 0, 0),
                                    //                   child: Column(
                                    //                     mainAxisSize:
                                    //                         MainAxisSize.max,
                                    //                     mainAxisAlignment:
                                    //                         MainAxisAlignment
                                    //                             .center,
                                    //                     crossAxisAlignment:
                                    //                         CrossAxisAlignment
                                    //                             .start,
                                    //                     children: [
                                    //                       Text(
                                    //                         'Username',
                                    //                         style: TextStyle(
                                    //                           fontFamily: 'Outfit',
                                    //                           color:
                                    //                               Color(0xFF1D2429),
                                    //                           fontSize: 14,
                                    //                           fontWeight:
                                    //                               FontWeight.normal,
                                    //                         ),
                                    //                       ),
                                    //                       Row(
                                    //                         mainAxisSize:
                                    //                             MainAxisSize.max,
                                    //                         children: [
                                    //                           Text(
                                    //                             'user@domainname.com',
                                    //                             style: TextStyle(
                                    //                               fontFamily:
                                    //                                   'Outfit',
                                    //                               color: Color(
                                    //                                   0xFF57636C),
                                    //                               fontSize: 14,
                                    //                               fontWeight:
                                    //                                   FontWeight
                                    //                                       .normal,
                                    //                             ),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ],
                                    //                   ),
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     // Padding(
                                    //     //   padding: EdgeInsetsDirectional.fromSTEB(
                                    //     //       16, 4, 16, 8),
                                    //     //   child: Container(
                                    //     //     width: double.infinity,
                                    //     //     height: 50,
                                    //     //     decoration: BoxDecoration(
                                    //     //       color: Colors.white,
                                    //     //       boxShadow: [
                                    //     //         BoxShadow(
                                    //     //           blurRadius: 4,
                                    //     //           color: Color(0x32000000),
                                    //     //           offset: Offset(0, 2),
                                    //     //         )
                                    //     //       ],
                                    //     //       borderRadius:
                                    //     //           BorderRadius.circular(8),
                                    //     //     ),
                                    //     //     child: Padding(
                                    //     //       padding:
                                    //     //           EdgeInsetsDirectional.fromSTEB(
                                    //     //               8, 0, 8, 0),
                                    //     //       child: Row(
                                    //     //         mainAxisSize: MainAxisSize.max,
                                    //     //         mainAxisAlignment:
                                    //     //             MainAxisAlignment.spaceBetween,
                                    //     //         children: [
                                    //     //           ClipRRect(
                                    //     //             borderRadius:
                                    //     //                 BorderRadius.circular(26),
                                    //     //             child: Image.network(
                                    //     //               'https://images.unsplash.com/photo-1463453091185-61582044d556?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzJ8fHVzZXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                                    //     //               width: 36,
                                    //     //               height: 36,
                                    //     //               fit: BoxFit.cover,
                                    //     //             ),
                                    //     //           ),
                                    //     //           Expanded(
                                    //     //             child: Padding(
                                    //     //               padding: EdgeInsetsDirectional
                                    //     //                   .fromSTEB(12, 0, 0, 0),
                                    //     //               child: Column(
                                    //     //                 mainAxisSize:
                                    //     //                     MainAxisSize.max,
                                    //     //                 mainAxisAlignment:
                                    //     //                     MainAxisAlignment
                                    //     //                         .center,
                                    //     //                 crossAxisAlignment:
                                    //     //                     CrossAxisAlignment
                                    //     //                         .start,
                                    //     //                 children: [
                                    //     //                   Text(
                                    //     //                     random_data.randomName(
                                    //     //                         true, true),
                                    //     //                     style: TextStyle(
                                    //     //                       fontFamily: 'Outfit',
                                    //     //                       color:
                                    //     //                           Color(0xFF1D2429),
                                    //     //                       fontSize: 14,
                                    //     //                       fontWeight:
                                    //     //                           FontWeight.normal,
                                    //     //                     ),
                                    //     //                   ),
                                    //     //                   Row(
                                    //     //                     mainAxisSize:
                                    //     //                         MainAxisSize.max,
                                    //     //                     children: [
                                    //     //                       Text(
                                    //     //                         'user@domainname.com',
                                    //     //                         style: TextStyle(
                                    //     //                           fontFamily:
                                    //     //                               'Outfit',
                                    //     //                           color: Color(
                                    //     //                               0xFF57636C),
                                    //     //                           fontSize: 14,
                                    //     //                           fontWeight:
                                    //     //                               FontWeight
                                    //     //                                   .normal,
                                    //     //                         ),
                                    //     //                       ),
                                    //     //                     ],
                                    //     //                   ),
                                    //     //                 ],
                                    //     //               ),
                                    //     //             ),
                                    //     //           ),
                                    //     //         ],
                                    //     //       ),
                                    //     //     ),
                                    //     //   ),
                                    //     // ),
                                    //   ],
                                    // ),
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget requestListElement(User user, bool isIncoming) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x32000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.network(
                  'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                  width: 36,
                  height: 36,
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
                      Text(
                        "${user.email}",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF1D2429),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "${user.firstName}",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                  width: 150,
                  height: 36,
                  // margin: EdgeInsets.all(25),
                  // FFButtonWidget(
                  child: isIncoming ? 
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    child: Text("Добавить"),
                    onPressed: () {
                      addFriend(user);
                      Navigator.pushNamed(context, '/');
                    },
                  ): 
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                    ),
                    child: Text("Отменить"),
                    // onPressed: () {},
                    onPressed: null,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void search() {
    AppState appState = Provider.of<AppState>(context, listen: false);
    String resource = "user";
    Map<String, dynamic> payload = {"q": textController.text};
    setState(() {
      searchQueryUid = "searchQuery#${Random().nextInt(1000)}";
      searchQuery = textController.text;
    });
    appState.socket.sendQuery(Query(resource, payload, uid: searchQueryUid));
  }
  void addFriend(User user) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    String resource = "friend";
    String addFrinedCommandUid = "addFrined#${user.id}";
    String action = "create";
    Map<String, dynamic> payload = {"user_id": user.id};

    appState.socket
        .sendCommand(Command(resource, payload, action, uid: addFrinedCommandUid));
  }

  Widget searchListElement(User user) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x32000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.network(
                  'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fHByb2ZpbGV8ZW58MHx8MHx8&auto=format&fit=crop&w=900&q=60',
                  width: 36,
                  height: 36,
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
                      Text(
                        "${user.email}",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color(0xFF1D2429),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "${user.firstName}",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF57636C),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 150,
                height: 36,
                // margin: EdgeInsets.all(25),
                child: ElevatedButton(
                  child: Text(
                    "Добавить",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Color.fromARGB(255, 58, 56, 56),
                      fontSize: 14,
                      // fontWeight: FontWeight.normal,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(primary: Color.fromARGB(96, 226, 237, 255)),
                  onPressed: () {
                    addFriend(user);
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
