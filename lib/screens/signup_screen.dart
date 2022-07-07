import "package:flutter/material.dart";
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import "package:go_router/go_router.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:pc_parts_list/common/widgets/form_builder_email_field.dart';
import 'package:pc_parts_list/common/widgets/form_builder_password_field.dart';
import 'package:pc_parts_list/common/widgets/form_builder_user_name_field.dart';
import 'package:pc_parts_list/common/widgets/information_dialog.dart';
import '../features/user/user.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "CREATE AN ACCOUNT",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 32),
                        FormBuilderEmailField(
                          name: "email",
                        ),
                        const SizedBox(height: 32),
                        FormBuilderUserNameField(
                          name: "userName",
                        ),
                        const SizedBox(height: 32),
                        const FormBuilderPasswordField(
                          name: "password",
                        ),
                        const SizedBox(height: 32),
                        FormBuilderTextField(
                          name: "firstName",
                          validator: ValidationBuilder().required().build(),
                          decoration: const InputDecoration(
                            labelText: "First Name",
                          ),
                        ),
                        const SizedBox(height: 32),
                        FormBuilderTextField(
                          name: "lastName",
                          validator: ValidationBuilder().required().build(),
                          decoration: const InputDecoration(
                            labelText: "Last Name",
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final email = _formKey.currentState!
                                  .getTransformedValue("email");
                              final password = _formKey.currentState!
                                  .getTransformedValue("password");
                              final userName = _formKey.currentState!
                                  .getTransformedValue("userName");
                              final firstName = _formKey.currentState!
                                  .getTransformedValue("firstName");
                              final lastName = _formKey.currentState!
                                  .getTransformedValue("lastName");

                              void goBackToLogin() => context.pop();

                              try {
                                await context.read<UsersService>().createUser(
                                      userName: userName,
                                      email: email,
                                      password: password,
                                      firstName: firstName,
                                      lastName: lastName,
                                    );
                                await showDialog(
                                  context: context,
                                  builder: (context) => const InformationDialog(
                                    titleText: "Registration successful",
                                  ),
                                );

                                goBackToLogin();
                              } on UserRepositoryException catch (e) {
                                await showDialog(
                                  context: context,
                                  builder: (context) => InformationDialog(
                                    titleText: e.message,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text("Signup"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text("Login"),
                            )
                          ],
                        ),
                      ],
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
