// import 'package:fluro/fluro.dart';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/register_confirm_page.dart';
import 'package:flutter_application_1/pages/room_list_page.dart';
import 'package:flutter_application_1/pages/room_page.dart';
import 'package:flutter_application_1/pages/search_user_page.dart';
import 'package:flutter_application_1/router.gr.dart';
import 'package:flutter_application_1/services/auth.dart';

class AuthRequiredGuard extends AutoRouteGuard {
  AuthRequiredGuard(this.authService);
  AuthService authService;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    print("naviget with auth");
    if (authService.isLogin()) {
      resolver.next(true);
      return;
    }
    router.replace(LoginPageWidgetRoute());
    // book was found. proceed to the page
  }
}

class AnonimusRequiredGuard extends AutoRouteGuard {
  AnonimusRequiredGuard(this.authService);
  AuthService authService;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    print("naviget with anonimus");
    if (!authService.isLogin()) {
      resolver.next(true);
      return;
    }
    router.replace(RoomListPageWidgetRoute());
    // book was found. proceed to the page
  }
}

@MaterialAutoRouter(
  // replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
        page: RoomListPageWidget, initial: true, guards: [AuthRequiredGuard]),
    AutoRoute(
        page: LoginPageWidget,
        path: LoginPageWidget.route,
        guards: [AnonimusRequiredGuard]),
    AutoRoute(
      page: ConfirmRegisterPageWidget,
      path: ConfirmRegisterPageWidget.baseRoute + "/:code",
      guards: [AnonimusRequiredGuard],
    ),
    AutoRoute(page: SearchUsersWidget, guards: [AuthRequiredGuard]),
    AutoRoute(
        page: RoomPageWidget,
        path: RoomPageWidget.baseRoute + "/:id",
        guards: [AuthRequiredGuard])
  ],
)
class $AppRouter {}

// class AppRouter {

//   static final AppRouter _instance = new AppRouter._internal();
//   final FluroRouter _router = FluroRouter();  // global router

//   factory AppRouter() {
//     return _instance;
//   }
//   AppRouter._internal();

//   // singleton
//   FluroRouter router() { return _router; }

//   void configureRoutes() {
//     _router.notFoundHandler = Handler(
//         handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       print("ROUTE $params WAS NOT FOUND !!!");
//       return;
//     });
//     _router.define(RoomListPageWidget.route, handler: rootHandler);
//     _router.define('/login', handler: loginRouteHandler);
//     _router.define(SearchUsersWidget.route,
//         handler: searchUserPageRouteHandler, transitionType: TransitionType.inFromLeft);
//     _router.define(ConfirmRegisterPageWidget.baseRoute + "/:code", handler: confirmRegisterRouteHandler);
//     _router.define(RoomPageWidget.baseRoute + "/:id", handler: roomPageRouteHandler);
//   }
// }
