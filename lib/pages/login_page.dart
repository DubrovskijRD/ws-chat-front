import 'package:flutter/material.dart';
import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/entity/auth.dart';
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_application_1/widgets/errors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key? key}) : super(key: key);

  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisibility = false;
  TextEditingController passwordConfirmController = TextEditingController();
  bool passwordConfirmVisibility = false;
  TextEditingController emailAddressLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  bool passwordLoginVisibility = false;
  bool _submitLogin = false;
  bool _submitRegister = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  

  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    emailAddressController = TextEditingController();
    passwordController = TextEditingController();
    passwordVisibility = false;
    passwordConfirmController = TextEditingController();
    passwordConfirmVisibility = false;
    emailAddressLoginController = TextEditingController();
    passwordLoginController = TextEditingController();
    passwordLoginVisibility = false;
    AppState appState = Provider.of<AppState>(context, listen: false);
    Future(() {
      
      if (appState.authService.isLogin()) {
        Navigator.pushNamed(context, '/');
      }
    });
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
                      length: 2,
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
                                text: 'Войти',
                              ),
                              Tab(
                                text: 'Зарегистрироваться',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                              minWidth: 100, maxWidth: 800),
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 0),
                                          child: TextFormField(
                                            controller:
                                                emailAddressLoginController,
                                            obscureText: false,
                                            onChanged: (text) =>
                                                setState(() {}),
                                            decoration: InputDecoration(
                                              errorText: _submitLogin
                                                  ? _errorTextEmailLogin
                                                  : null,
                                              errorBorder: OutlineInputBorder(),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              labelText: 'Почта',
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
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
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
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(20, 24, 20, 24),
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
                                        Container(
                                          constraints: BoxConstraints(
                                              minWidth: 100, maxWidth: 800),
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 12, 0, 0),
                                          child: TextFormField(
                                            controller: passwordLoginController,
                                            onChanged: (text) =>
                                                setState(() {}),
                                            obscureText:
                                                !passwordLoginVisibility,
                                            decoration: InputDecoration(
                                              errorText: _submitLogin
                                                  ? _errorTextPasswordLogin
                                                  : null,
                                              errorBorder: OutlineInputBorder(),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              labelText: 'Пароль',
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
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0x00000000),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(20, 24, 20, 24),
                                              suffixIcon: InkWell(
                                                onTap: () => setState(
                                                  () => passwordLoginVisibility =
                                                      !passwordLoginVisibility,
                                                ),
                                                child: Icon(
                                                  passwordLoginVisibility
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: Color(0xFF95A1AC),
                                                  size: 20,
                                                ),
                                              ),
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
                                                  await loginAction();
                                                },
                                                child: Text("Войти"),
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
                                      ],
                                    )),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      44, 0, 44, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth: 100, maxWidth: 800),
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 0),
                                        child: TextFormField(
                                          controller: emailAddressController,
                                          onChanged: (text) => setState(() {}),
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            errorText: _submitRegister
                                                ? _errorTextEmailRegister
                                                : null,
                                            errorBorder: OutlineInputBorder(),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            labelText: 'Почта',
                                            labelStyle:
                                                // FlutterFlowTheme.of(context)
                                                //     .subtitle2
                                                //     .override(
                                                const TextStyle(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF57636C),
                                              fontSize: 16,
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
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
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
                                              //     .bodyText1
                                              //     .override(
                                              const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF14181B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth: 100, maxWidth: 800),
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 0),
                                        child: TextFormField(
                                          controller: passwordController,
                                          onChanged: (text) => setState(() {}),
                                          obscureText: !passwordVisibility,
                                          decoration: InputDecoration(
                                            errorText: _submitRegister
                                                ? _errorTextPasswordRegister
                                                : null,
                                            errorBorder: OutlineInputBorder(),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            labelText: 'Пароль',
                                            labelStyle:
                                                // FlutterFlowTheme.of(context)
                                                //     .subtitle2
                                                //     .override(
                                                const TextStyle(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF57636C),
                                              fontSize: 16,
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
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
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
                                            suffixIcon: InkWell(
                                              onTap: () => setState(
                                                () => passwordVisibility =
                                                    !passwordVisibility,
                                              ),
                                              child: Icon(
                                                passwordVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: Color(0xFF95A1AC),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          style:
                                              // FlutterFlowTheme.of(context)
                                              //     .bodyText1
                                              //     .override(
                                              const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF14181B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                            minWidth: 100, maxWidth: 800),
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 0),
                                        child: TextFormField(
                                          controller: passwordConfirmController,
                                          onChanged: (text) => setState(() {}),
                                          obscureText:
                                              !passwordConfirmVisibility,
                                          decoration: InputDecoration(
                                            errorText: _submitRegister
                                                ? _errorTextPasswordConfirmRegister
                                                : null,
                                            errorBorder: OutlineInputBorder(),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            labelText: 'Повторите пароль',
                                            labelStyle:
                                                // FlutterFlowTheme.of(context)
                                                //     .subtitle2
                                                //     .override(
                                                const TextStyle(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF57636C),
                                              fontSize: 16,
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
                                              borderSide: BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Color(0x00000000),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
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
                                            suffixIcon: InkWell(
                                              onTap: () => setState(
                                                () => passwordConfirmVisibility =
                                                    !passwordConfirmVisibility,
                                              ),
                                              child: Icon(
                                                passwordConfirmVisibility
                                                    ? Icons.visibility_outlined
                                                    : Icons
                                                        .visibility_off_outlined,
                                                color: Color(0xFF95A1AC),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          style:
                                              // FlutterFlowTheme.of(context)
                                              //     .bodyText1
                                              //     .override(
                                              const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Color(0xFF14181B),
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 24, 0, 0),
                                        child: Container(
                                          width: 160,
                                          height: 40,
                                          margin: EdgeInsets.all(25),
                                          // FFButtonWidget(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.grey,
                                              ),
                                              onPressed: () async {
                                                await registerAction();
                                              },
                                              child:
                                                  const Text("Создать аккаунт")
                                              // text: 'Create Account',
                                              // options: FFButtonOptions(
                                              //   width: 230,
                                              //   height: 50,
                                              //   color: FlutterFlowTheme.of(context)
                                              //       .secondaryColor,
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
                                              //   elevation: 3,
                                              //   borderSide: BorderSide(
                                              //     color: Colors.transparent,
                                              //     width: 1,
                                              //   ),
                                              //   borderRadius: 8,
                                              // ),
                                              ),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 24, 0, 24),
                                        child:
                                            // FFButtonWidget(
                                            TextButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/register/confirm');
                                          },
                                          child: const Text(
                                              "Уже есть код подтверждения?"),
                                          // text: 'already have confirm code?',
                                          // options: FFButtonOptions(
                                          //   width: double.infinity,
                                          //   height: 40,
                                          //   color: Color(0x004B39EF),
                                          //   textStyle:
                                          //       FlutterFlowTheme.of(context)
                                          //           .subtitle2
                                          //           .override(
                                          //             fontFamily: 'Poppins',
                                          //             color: Color(0x8CFFFFFF),
                                          //             fontSize: 10,
                                          //             fontWeight:
                                          //                 FontWeight.w200,
                                          //           ),
                                          //   borderSide: BorderSide(
                                          //     color: Colors.transparent,
                                          //     width: 1,
                                          //   ),
                                          //   borderRadius: 12,
                                          // ),
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

  String? get _errorTextEmailLogin {
    // at any time, we can get the text from _controller.value.text
    final email = emailAddressLoginController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (email.isEmpty) {
      return 'Заполните поле!';
    }
    if (!EmailValidator.validate(email)) {
      return 'Некорректный адрес!';
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorTextPasswordLogin {
    // at any time, we can get the text from _controller.value.text
    final password = passwordLoginController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (password.isEmpty) {
      return 'Заполните поле!';
    }
    if (password.length < 8) {
      return 'Короткий пароль';
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorTextEmailRegister {
    // at any time, we can get the text from _controller.value.text
    final email = emailAddressController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (email.isEmpty) {
      return 'Заполните поле!';
    }
    if (!EmailValidator.validate(email)) {
      return 'Некорректный адрес!';
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorTextPasswordRegister {
    // at any time, we can get the text from _controller.value.text
    final password = passwordController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (password.isEmpty) {
      return 'Заполните поле!';
    }
    if (password.length < 8) {
      return 'Короткий пароль';
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorTextPasswordConfirmRegister {
    // at any time, we can get the text from _controller.value.text
    final password = passwordController.value.text;
    final passwordConfirm = passwordConfirmController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (password != passwordConfirm) {
      return 'Пароли не совпадают';
    }
    // return null if the text is valid
    return null;
  }

  Future<void> authorize(String email, String password) async {
    SessionData session = await login(email, password);
    AppState appState = Provider.of<AppState>(context, listen: false);
    appState.authService.setAuth(session.email, session.token, session.id);
  }

  loginAction() async {
    try {
      setState(() => _submitLogin = true);
      if (_errorTextEmailLogin != null || _errorTextPasswordLogin != null) {
        return;
      }
      await authorize(
        emailAddressLoginController.text,
        passwordLoginController.text,
      );
      AppState appState = Provider.of<AppState>(context, listen: false);
      appState.connect();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } on AuthError catch (e) {
      String title = "Ошибка авторизации";
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

  registerAction() async {
    try {
      setState(() => _submitRegister = true);
      if (_errorTextEmailRegister != null ||
          _errorTextPasswordRegister != null ||
          _errorTextPasswordConfirmRegister != null) {
        return;
      }
      await register(
        emailAddressController.text,
        passwordController.text,
      );
      Navigator.pushNamedAndRemoveUntil(
          context, '/register/confirm', (route) => false);
    } on AuthError catch (e) {
      String title = "Ошибка регистрации";
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
