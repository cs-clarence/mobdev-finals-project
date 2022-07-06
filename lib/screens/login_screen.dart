import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_validator/form_validator.dart';
import "package:go_router/go_router.dart";
import 'package:pc_parts_list/common/widgets/form_builder_password_field.dart';
import 'package:pc_parts_list/features/parts_list/parts_list.dart';
import '../features/user/user.dart';

class LoginIntent extends Intent {}

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: Card(
            child: BlocListener<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserLoadFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errors.join(". "),
                      ),
                    ),
                  );
                }

                if (state is UserLoadSuccess) {
                  context.pushNamed("parts-list");
                  context.read<PartsListsBloc>().add(
                        PartsListsForUserLoaded(
                          userName: state.user.account.userName,
                        ),
                      );
                  context.read<PcPartsBloc>().add(
                        const PcPartsLoaded(),
                      );
                }
              },
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/logo.png", width: 96),
                      const SizedBox(height: 8),
                      Text(
                        "PC Parts List",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 32),
                      FormBuilderTextField(
                        name: "userNameOrEmail",
                        validator:
                            ValidationBuilder().required().minLength(8).build(),
                        decoration: const InputDecoration(
                          labelText: "Username Or Email",
                        ),
                      ),
                      const SizedBox(height: 32),
                      const FormBuilderPasswordField(
                        name: "password",
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final userNameOrEmail = _formKey.currentState!
                                .getTransformedValue("userNameOrEmail");
                            final password = _formKey.currentState!
                                .getTransformedValue("password");

                            context.read<UserBloc>().add(UserLoggedIn(
                                  userNameOrEmail: userNameOrEmail,
                                  password: password,
                                ));
                          }
                        },
                        child: const Text("Login"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?"),
                          TextButton(
                            onPressed: () => context.pushNamed("signup"),
                            child: const Text("Signup"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
