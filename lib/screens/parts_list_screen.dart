import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:go_router/go_router.dart";
import 'package:pc_parts_list/common/widgets/confirmation_dialog.dart';
import 'package:pc_parts_list/features/parts_list/parts_list.dart';
import 'package:pc_parts_list/screens/loading_screen.dart';
import '../features/user/user.dart';

class PartsListScreen extends StatefulWidget {
  const PartsListScreen({Key? key}) : super(key: key);

  @override
  State<PartsListScreen> createState() => _PartsListScreenState();
}

class _PartsListScreenState extends State<PartsListScreen>
    with SingleTickerProviderStateMixin {
  bool showLoadingScreen = true;
  late final Animation<double> _animation;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 1,
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          setState(() => showLoadingScreen = false);
        }
      },
    );
    Timer(
      const Duration(seconds: 3),
      () => _controller.animateTo(
        0,
        duration: const Duration(
          milliseconds: 300,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = context.watch<UserBloc>();

    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            tooltip: "Create Parts List",
            onPressed: () {
              context.read<PcPartsBloc>().add(const PcPartsLoaded());
              context.goNamed("parts-list-create");
            },
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          drawer: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              final isAdmin =
                  (state as UserLoadSuccess).user.account.accessLevel >= 10;

              return Drawer(
                child: ListView(
                  primary: false,
                  children: [
                    DrawerHeader(
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_circle),
                      title: const Text("User Settings"),
                      onTap: () => context.pushNamed("user-settings"),
                    ),
                    if (isAdmin) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Admin Access",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.list),
                        title: const Text("PC Parts"),
                        onTap: () {
                          context.pushNamed("pc-parts");
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_circle),
                        title: const Text("Users"),
                        onTap: () {
                          context.pushNamed("users");
                        },
                      ),
                    ],
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text("Log Out"),
                      onTap: () async {
                        void logOut() {
                          context.pop();
                        }

                        final shouldLogOut = await showDialog<bool>(
                              context: context,
                              builder: (context) => const ConfirmationDialog(
                                titleText: "Are you sure you want to log out?",
                              ),
                            ) ??
                            false;
                        if (shouldLogOut) {
                          logOut();
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text("About"),
                      onTap: () => context.pushNamed("about"),
                    ),
                  ],
                ),
              );
            },
          ),
          appBar: AppBar(
            title: const Text("PC Parts List"),
          ),
          body: SizedBox(
            width: double.infinity,
            child: BlocBuilder<PartsListsBloc, PartsListsState>(
              builder: (context, state) {
                if (state is PartsListsLoadSuccess) {
                  if (state.partsLists.isNotEmpty) {
                    final partsLists = state.partsLists.toList();

                    return ListView.builder(
                      itemCount: partsLists.length,
                      itemBuilder: (context, index) {
                        final partsList = partsLists[index];
                        double price = 0.0;

                        for (final pcPart in partsList.parts) {
                          price += pcPart.price;
                        }

                        return ListTile(
                          title: Text(partsList.name),
                          subtitle: Text("PHP $price"),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == "edit") {
                                context.goNamed("parts-list-edit", params: {
                                  "partsListId": partsList.id,
                                });
                              } else if (value == "delete") {
                                final userName =
                                    (userBloc.state as UserLoadSuccess)
                                        .user
                                        .account
                                        .userName;

                                void deleteIt() =>
                                    context.read<PartsListsBloc>().add(
                                          PartsListsForUserDeleted(
                                            partsListId: partsList.id,
                                            userName: userName,
                                          ),
                                        );

                                final result = await showDialog<bool?>(
                                  context: context,
                                  builder: (context) => ConfirmationDialog(
                                    titleText:
                                        "Delete Part List ${partsList.name}?",
                                    contentText: "This action is irreversible.",
                                  ),
                                );

                                if (result == true) deleteIt();
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: "edit",
                                child: Text("Edit"),
                              ),
                              const PopupMenuItem(
                                value: "delete",
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                            "You have no parts lists, click the + button to create one"),
                      ],
                    );
                  }
                } else if (state is PartsListsInitial ||
                    state is PartsListsLoadInProgress) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 32,
                      ),
                      Text("Loading Parts List"),
                    ],
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Error encountered when loading"),
                      const SizedBox(
                        height: 32,
                      ),
                      TextButton(
                        onPressed: () {
                          final userName = (context.read<UserBloc>().state
                                  as UserLoadSuccess)
                              .user
                              .account
                              .userName;

                          context
                              .read<PartsListsBloc>()
                              .add(PartsListsForUserLoaded(userName: userName));
                        },
                        child: const Text("Reload"),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        if (showLoadingScreen)
          FadeTransition(
            opacity: _animation,
            child: const LoadingScreen(),
          ),
      ],
    );
  }
}
