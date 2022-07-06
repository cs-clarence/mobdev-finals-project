import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:pc_parts_list/common/widgets/form_builder_email_field.dart';
import 'package:pc_parts_list/common/widgets/form_builder_password_field.dart';
import 'package:pc_parts_list/common/widgets/form_builder_user_name_field.dart';
import 'package:pc_parts_list/common/widgets/information_dialog.dart';
import 'package:pc_parts_list/features/user/user.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  late final GlobalKey<FormBuilderState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormBuilderState>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

    final required = ValidationBuilder().required().build();

    assert(
      userBloc.state is UserLoadSuccess,
      "User should be logged in before being able to open this screen",
    );

    final user = (userBloc.state as UserLoadSuccess).user;
    final originalUserName = user.account.userName;

    final userMap = {...user.account.toJson(), ...user.profile.toJson()};

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Settings"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: FormBuilder(
                initialValue: userMap,
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Account",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderUserNameField(
                      name: "userName",
                    ),
                    const SizedBox(height: 32),
                    FormBuilderEmailField(
                      name: "email",
                    ),
                    const SizedBox(height: 32),
                    const FormBuilderPasswordField(
                      name: "password",
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 32),
                    Text(
                      "Profile",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: "firstName",
                      validator: required,
                      decoration: const InputDecoration(
                        labelText: "First Name",
                      ),
                    ),
                    const SizedBox(height: 32),
                    FormBuilderTextField(
                      name: "middleName",
                      decoration: const InputDecoration(
                        labelText: "Middle Name",
                      ),
                    ),
                    const SizedBox(height: 32),
                    FormBuilderTextField(
                      name: "lastName",
                      validator: required,
                      decoration: const InputDecoration(
                        labelText: "Last Name",
                      ),
                    ),
                    const SizedBox(height: 32),
                    FormBuilderTextField(
                      name: "nameSuffix",
                      decoration: const InputDecoration(
                        labelText: "Name Suffix",
                      ),
                    ),
                    const SizedBox(height: 32),
                    OutlinedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final userName = _formKey.currentState!
                              .getTransformedValue("userName");
                          final password = _formKey.currentState!
                              .getTransformedValue("password");
                          final email = _formKey.currentState!
                              .getTransformedValue("email");
                          final firstName = _formKey.currentState!
                              .getTransformedValue("firstName");
                          final middleName = _formKey.currentState!
                              .getTransformedValue("middleName");
                          final lastName = _formKey.currentState!
                              .getTransformedValue("lastName");
                          final nameSuffix = _formKey.currentState!
                              .getTransformedValue("nameSuffix");

                          userBloc.add(
                            UserUpdated(
                              userName: originalUserName,
                              newUserName: userName,
                              newEmail: email,
                              newFirstName: firstName,
                              newLastName: lastName,
                              newMiddleName: middleName,
                              newNameSuffix: nameSuffix,
                              newPassword: password,
                            ),
                          );

                          await showDialog(
                            context: context,
                            builder: (context) => const InformationDialog(
                              titleText: "Saved",
                              contentText: "Your settings are saved.",
                            ),
                          );
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
