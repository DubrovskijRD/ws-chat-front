import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/entity/auth.dart';
import 'package:flutter_application_1/router.gr.dart';
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_application_1/widgets/errors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';

class ConfirmRegisterPageWidget extends StatefulWidget {
  // const ConfirmRegisterPageWidget({Key? key, this.code}) : super(key: key);
  const ConfirmRegisterPageWidget({Key? key, @PathParam('code') this.code}): super(key: key);

  static const String baseRoute = '/register/confirm';
  static String Function(String code) routeFromCode =
      (String code) => baseRoute + '/$code';

  final String? code;

  @override
  _ConfirmRegisterPagerWidgetState createState() =>
      _ConfirmRegisterPagerWidgetState();
}

class _ConfirmRegisterPagerWidgetState
    extends State<ConfirmRegisterPageWidget> {
  TextEditingController confirmCodeController = TextEditingController();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    confirmCodeController = TextEditingController();
    if (widget.code != null){
      confirmCodeController.text = widget.code!;
    }
    AppState appState = Provider.of<AppState>(context, listen: false);
    // Future(() {
    //   if (appState.authService.isLogin()) {
    //     appState.router.replace(RoomListPageWidgetRoute());
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFF14181B),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 1,
          decoration: BoxDecoration(
            color: Color(0xFF14181B),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.network(
                'https://images.unsplash.com/photo-1644329447491-09a81c2e3d80',
              ).image,
            ),
          ),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0x990F1113),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.diceD6,
                          // color: FlutterFlowTheme.of(context).lineColor,
                          color: Colors.lightBlueAccent,
                          size: 44,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 1,
                      initialIndex: 0,
                      child: Column(
                        children: [
                          const TabBar(
                            isScrollable: true,
                            labelColor: Colors.white,
                            labelStyle:
                                // FlutterFlowTheme.of(context).subtitle1.override(
                                TextStyle(
                              fontFamily: 'Outfit',
                              color: Color(0xFF0F1113),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            indicatorColor: Colors.white,
                            tabs: [
                              Tab(
                                text: 'Подтверждение почты',
                              ),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      44, 0, 44, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth: 100, maxWidth: 800),
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 0),
                                        child: TextFormField(
                                          controller: confirmCodeController,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            labelText: 'Код подтверждения',
                                            labelStyle:
                                                // FlutterFlowTheme.of(context)
                                                //     .bodyText1
                                                //     .override(
                                                const TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Color(0xFF95A1AC),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            hintStyle:
                                                // FlutterFlowTheme.of(context)
                                                //     .bodyText1
                                                //     .override(
                                                const TextStyle(
                                              fontFamily: 'Lexend Deca',
                                              color: Color(0xFF95A1AC),
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 24, 20, 24),
                                          ),
                                          style:
                                              // FlutterFlowTheme.of(context)
                                              //     .subtitle2
                                              //     .override(
                                              const TextStyle(
                                            fontFamily: 'Outfit',
                                            color: Color(0xFF0F1113),
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 24, 0, 0),
                                          child: Container(
                                            width: 160,
                                            height: 40,
                                            margin: EdgeInsets.all(25),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.grey,
                                              ),
                                              onPressed: () async {
                                                await confirmAction();
                                              },
                                              child: Text("Отправить"),
                                              // text: 'Login',
                                              // options: FFButtonOptions(
                                              //   width: 230,
                                              //   height: 50,
                                              //   color: Color(0xFF39D2C0),
                                              //   textStyle:
                                              //       FlutterFlowTheme.of(context)
                                              //           .subtitle2
                                              //           .override(
                                              //             fontFamily: 'Lexend Deca',
                                              //             color: Colors.white,
                                              //             fontSize: 16,
                                              //             fontWeight:
                                              //                 FontWeight.normal,
                                              //           ),
                                              // elevation: 3,
                                              // borderSide: BorderSide(
                                              //   color: Colors.transparent,
                                              //   width: 1,
                                              // ),
                                              // borderRadius: 8,
                                            ),
                                          )),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 24, 0, 24),
                                        child:
                                            // FFButtonWidget(
                                            TextButton(
                                          onPressed: () {
                                            Provider.of<AppState>(context, listen: false).router.pop();
                                          },
                                          child: const Text("Назад"),
                                        ),
                                      ),
                                    ],
                                  ),
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
          ),
        ),
      ),
    );
  }

  confirmAction() async {
    try {
      await confirm(confirmCodeController.text);
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Успех! :)'),
            content:
                Text("Теперь вы зарегистрированы и можете войти в систему."),
            actions: <Widget>[
              TextButton(
                child: const Text('На страницу входа.'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
              ),
            ],
          );
        },
      );
    } on AuthError catch (e) {
      String title = "Ошибка подтверждения";
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              buildError(context, title, e.message));
    } catch (e) {
      String title = "Ошибка сервера";
      showDialog(
          context: context,
          builder: (BuildContext context) => buildError(context, title, {}));
    }
  }
}
