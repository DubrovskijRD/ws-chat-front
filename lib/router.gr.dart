// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import 'pages/login_page.dart' as _i2;
import 'pages/register_confirm_page.dart' as _i3;
import 'pages/room_list_page.dart' as _i1;
import 'pages/room_page.dart' as _i5;
import 'pages/search_user_page.dart' as _i4;
import 'router.dart' as _i8;

class AppRouter extends _i6.RootStackRouter {
  AppRouter(
      {_i7.GlobalKey<_i7.NavigatorState>? navigatorKey,
      required this.authRequiredGuard,
      required this.anonimusRequiredGuard})
      : super(navigatorKey);

  final _i8.AuthRequiredGuard authRequiredGuard;

  final _i8.AnonimusRequiredGuard anonimusRequiredGuard;

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    RoomListPageWidgetRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.RoomListPageWidget());
    },
    LoginPageWidgetRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.LoginPageWidget());
    },
    ConfirmRegisterPageWidgetRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ConfirmRegisterPageWidgetRouteArgs>(
          orElse: () => ConfirmRegisterPageWidgetRouteArgs(
              code: pathParams.optString('code')));
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.ConfirmRegisterPageWidget(key: args.key, code: args.code));
    },
    SearchUsersWidgetRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i4.SearchUsersWidget());
    },
    RoomPageWidgetRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<RoomPageWidgetRouteArgs>(
          orElse: () =>
              RoomPageWidgetRouteArgs(roomId: pathParams.getInt('id')));
      return _i6.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i5.RoomPageWidget(key: args.key, roomId: args.roomId));
    }
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(RoomListPageWidgetRoute.name,
            path: '/', guards: [authRequiredGuard]),
        _i6.RouteConfig(LoginPageWidgetRoute.name,
            path: 'login', guards: [anonimusRequiredGuard]),
        _i6.RouteConfig(ConfirmRegisterPageWidgetRoute.name,
            path: '/register/confirm/:code', guards: [anonimusRequiredGuard]),
        _i6.RouteConfig(SearchUsersWidgetRoute.name,
            path: '/search-users-widget', guards: [authRequiredGuard]),
        _i6.RouteConfig(RoomPageWidgetRoute.name,
            path: '/room/:id', guards: [authRequiredGuard])
      ];
}

/// generated route for
/// [_i1.RoomListPageWidget]
class RoomListPageWidgetRoute extends _i6.PageRouteInfo<void> {
  const RoomListPageWidgetRoute()
      : super(RoomListPageWidgetRoute.name, path: '/');

  static const String name = 'RoomListPageWidgetRoute';
}

/// generated route for
/// [_i2.LoginPageWidget]
class LoginPageWidgetRoute extends _i6.PageRouteInfo<void> {
  const LoginPageWidgetRoute()
      : super(LoginPageWidgetRoute.name, path: 'login');

  static const String name = 'LoginPageWidgetRoute';
}

/// generated route for
/// [_i3.ConfirmRegisterPageWidget]
class ConfirmRegisterPageWidgetRoute
    extends _i6.PageRouteInfo<ConfirmRegisterPageWidgetRouteArgs> {
  ConfirmRegisterPageWidgetRoute({_i7.Key? key, String? code})
      : super(ConfirmRegisterPageWidgetRoute.name,
            path: '/register/confirm/:code',
            args: ConfirmRegisterPageWidgetRouteArgs(key: key, code: code),
            rawPathParams: {'code': code});

  static const String name = 'ConfirmRegisterPageWidgetRoute';
}

class ConfirmRegisterPageWidgetRouteArgs {
  const ConfirmRegisterPageWidgetRouteArgs({this.key, this.code});

  final _i7.Key? key;

  final String? code;

  @override
  String toString() {
    return 'ConfirmRegisterPageWidgetRouteArgs{key: $key, code: $code}';
  }
}

/// generated route for
/// [_i4.SearchUsersWidget]
class SearchUsersWidgetRoute extends _i6.PageRouteInfo<void> {
  const SearchUsersWidgetRoute()
      : super(SearchUsersWidgetRoute.name, path: '/search-users-widget');

  static const String name = 'SearchUsersWidgetRoute';
}

/// generated route for
/// [_i5.RoomPageWidget]
class RoomPageWidgetRoute extends _i6.PageRouteInfo<RoomPageWidgetRouteArgs> {
  RoomPageWidgetRoute({_i7.Key? key, required int roomId})
      : super(RoomPageWidgetRoute.name,
            path: '/room/:id',
            args: RoomPageWidgetRouteArgs(key: key, roomId: roomId),
            rawPathParams: {'id': roomId});

  static const String name = 'RoomPageWidgetRoute';
}

class RoomPageWidgetRouteArgs {
  const RoomPageWidgetRouteArgs({this.key, required this.roomId});

  final _i7.Key? key;

  final int roomId;

  @override
  String toString() {
    return 'RoomPageWidgetRouteArgs{key: $key, roomId: $roomId}';
  }
}
