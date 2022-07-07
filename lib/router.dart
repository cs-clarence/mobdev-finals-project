import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:go_router/go_router.dart";
import 'package:pc_parts_list/features/user/user.dart';
import 'package:pc_parts_list/screens/about_screen.dart';
import 'package:pc_parts_list/screens/parts_list_create_screen.dart';
import 'package:pc_parts_list/screens/parts_list_edit_screen.dart';
import 'package:pc_parts_list/screens/pc_parts_screen.dart';
import 'package:pc_parts_list/screens/user_settings_screen.dart';
import 'package:pc_parts_list/screens/parts_list_screen.dart';
import 'package:pc_parts_list/screens/users_screen.dart';
import "./screens/login_screen.dart";
import "./screens/signup_screen.dart";

GoRouter buildRouter(BuildContext context) {
  final userBloc = context.watch<UserBloc>();

  return GoRouter(
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    initialLocation: "/login",
    routes: [
      GoRoute(
        path: "/parts-list",
        name: "parts-list",
        builder: (context, routerState) => const PartsListScreen(),
        routes: [
          GoRoute(
            path: "create",
            name: "parts-list-create",
            builder: (context, routerState) => PartsListCreateScreen(),
          ),
          GoRoute(
            path: "edit/:partsListId",
            name: "parts-list-edit",
            builder: (context, routerState) => PartsListEditScreen(
              partsListId: routerState.params["partsListId"] as String,
            ),
          ),
        ],
      ),
      GoRoute(
        path: "/login",
        name: "login",
        builder: (context, routerState) => LoginScreen(),
      ),
      GoRoute(
        path: "/signup",
        name: "signup",
        builder: (context, routerState) => SignupScreen(),
      ),
      GoRoute(
        path: "/about",
        name: "about",
        builder: (context, routerState) => const AboutScreen(),
      ),
      GoRoute(
        path: "/user-settings",
        name: "user-settings",
        builder: (context, routerState) => const UserSettingsScreen(),
      ),
      GoRoute(
        path: "/users",
        name: "users",
        builder: (context, routerState) => const UsersScreen(),
      ),
      GoRoute(
        path: "/pc-parts",
        name: "pc-parts",
        builder: (context, routerState) => const PcPartsScreen(),
      ),
    ],
  );
}
