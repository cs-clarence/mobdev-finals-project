import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import '../features/user/user.dart';

class HomeScreen extends StatelessWidget {
  final UserBloc _userBloc;
  const HomeScreen({Key? key, required UserBloc userBloc})
      : _userBloc = userBloc,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PC Parts List"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.account_circle),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "login",
                  child: const Text("Login"),
                  onTap: () => context.goNamed("login"),
                ),
              ];
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "About",
                  child: const Text("About"),
                  onTap: () => context.goNamed("about"),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}
