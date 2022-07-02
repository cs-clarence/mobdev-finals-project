import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:go_router/go_router.dart";
import 'package:pcpartslist/features/user/user.dart';
import 'package:pcpartslist/screens/about_screen.dart';
import 'package:pcpartslist/screens/home_screen.dart';
import "./screens/login_screen.dart";
import "./screens/signup_screen.dart";

bool isLoggedIn = false;

GoRouter buildRouter(BuildContext context) {
  final userBloc = context.read<UserBloc>();

  return GoRouter(
    routes: [
      GoRoute(
        path: "/",
        name: "home",
        redirect: (routerState) =>
            userBloc.state is UserLoadInProgress ? "/" : "/login",
        builder: (context, routerState) => HomeScreen(userBloc: userBloc),
        routes: [
          GoRoute(
            name: "login",
            path: "login",
            builder: (context, routerState) => LoginScreen(userBloc: userBloc),
          ),
          GoRoute(
            name: "signup",
            path: "signup",
            builder: (context, routerState) => SignupScreen(userBloc: userBloc),
          ),
          GoRoute(
            name: "about",
            path: "about",
            builder: (context, routerState) => const AboutScreen(),
          ),
        ],
      ),
    ],
  );
}
