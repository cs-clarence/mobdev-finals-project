import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import 'package:pc_parts_list/common/widgets/information_dialog.dart';
import 'package:pc_parts_list/features/user/user.dart';
import 'package:provider/provider.dart';

import '../common/widgets/confirmation_dialog.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final createUser = context.read<UsersService>().createUser;
          final result = await showDialog<Map<String, dynamic>?>(
            context: context,
            builder: (context) {
              return const UserFormDialog(
                titleText: "CREATE USER",
                submitButtonText: "Save",
                mode: UserFormMode.create,
              );
            },
          );
          if (result != null) {
            try {
              await createUser(
                userName: result["userName"],
                email: result["email"],
                password: result["password"],
                firstName: result["firstName"],
                lastName: result["lastName"],
                accessLevel: result["accessLevel"],
                middleName: result["middleName"],
                nameSuffix: result["nameSuffix"],
              );
            } on UserRepositoryException catch (e) {
              await showDialog(
                context: context,
                builder: (context) {
                  return InformationDialog(
                    titleText: "Can't Create User",
                    contentText: e.message,
                  );
                },
              );
            }
          }
        },
      ),
      body: Consumer<UsersService>(
        builder: (context, userService, child) {
          final users = userService.getAllUsers();

          return FutureBuilder<Iterable<UserModel>>(
              future: users,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Action")),
                          DataColumn(label: Text("UserName")),
                          DataColumn(label: Text("Email")),
                          DataColumn(label: Text("Password")),
                          DataColumn(label: Text("Access Level")),
                          DataColumn(label: Text("First Name")),
                          DataColumn(label: Text("Middle Name")),
                          DataColumn(label: Text("Last Name")),
                          DataColumn(label: Text("Name Suffix")),
                        ],
                        rows: [
                          for (final user in snapshot.data!)
                            DataRow(cells: [
                              DataCell(PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == "delete") {
                                    final currentUserUserName = (context
                                            .read<UserBloc>()
                                            .state as UserLoadSuccess)
                                        .user
                                        .account
                                        .userName;
                                    final toBeDeletedUserUserName =
                                        user.account.userName;
                                    final logOutUser = currentUserUserName ==
                                        toBeDeletedUserUserName;

                                    void deleteIt() => context
                                        .read<UsersService>()
                                        .deleteUser(user.account.userName);
                                    void logOut() => context
                                        .read<UserBloc>()
                                        .add(const UserLoggedOut());

                                    final result = await showDialog<bool?>(
                                      context: context,
                                      builder: (context) => ConfirmationDialog(
                                        titleText:
                                            "Delete User ${user.account.userName} ${logOutUser ? "And Log Out " : ""}?",
                                        contentText:
                                            "This action is irreversible.",
                                      ),
                                    );

                                    if (result == true) deleteIt();
                                    if (logOutUser && result == true) {
                                      logOut();
                                    }
                                  } else if (value == "edit") {
                                    final result =
                                        await showDialog<Map<String, dynamic>?>(
                                      context: context,
                                      builder: (context) {
                                        return UserFormDialog(
                                          initialValue: {
                                            ...user.account.toJson(),
                                            ...user.profile.toJson(),
                                          },
                                          titleText: "EDIT USER",
                                          submitButtonText: "Update",
                                          mode: UserFormMode.edit,
                                        );
                                      },
                                    );
                                    if (result != null) {
                                      final profile =
                                          ProfileModel.fromJson(result);
                                      final account =
                                          AccountModel.fromJson(result);
                                      try {
                                        await userService.updateUser(
                                          userName: user.account.userName,
                                          newAccessLevel: account.accessLevel,
                                          newUserName: account.userName,
                                          newEmail: account.email,
                                          newFirstName: profile.firstName,
                                          newPassword: account.password,
                                          newNameSuffix: profile.nameSuffix,
                                          newMiddleName: profile.middleName,
                                          newLastName: profile.lastName,
                                        );
                                      } on UserRepositoryException catch (e) {
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return InformationDialog(
                                              titleText: "Can't Update User",
                                              contentText: e.message,
                                            );
                                          },
                                        );
                                      }

                                    }
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: "edit",
                                    child: Text("Edit"),
                                  ),
                                  PopupMenuItem(
                                    value: "delete",
                                    child: Text("Delete"),
                                  ),
                                ],
                              )),
                              DataCell(Text(user.account.userName)),
                              DataCell(Text(user.account.email)),
                              DataCell(Text(user.account.password)),
                              DataCell(Text("${user.account.accessLevel}")),
                              DataCell(Text(user.profile.firstName)),
                              DataCell(Text(user.profile.middleName ?? "")),
                              DataCell(Text(user.profile.lastName)),
                              DataCell(Text(user.profile.nameSuffix ?? "")),
                            ]),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              });
        },
      ),
    );
  }
}
