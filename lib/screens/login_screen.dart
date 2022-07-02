import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import "package:go_router/go_router.dart";
import '../features/user/user.dart';

class LoginIntent extends Intent {}

class LoginScreen extends StatelessWidget {
  final UserBloc _userBloc;
  final _formKey = GlobalKey<FormState>();
  final _userNameOrEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({Key? key, required UserBloc userBloc})
      : _userBloc = userBloc,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: Card(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "LOGIN",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _userNameOrEmailController,
                      validator:
                          ValidationBuilder().required().minLength(8).build(),
                      decoration: const InputDecoration(
                        labelText: "Username Or Email",
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _passwordController,
                      validator:
                          ValidationBuilder().required().minLength(8).build(),
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _userBloc.add(UserLoggedIn(
                            userNameOrEmail: _userNameOrEmailController.text,
                            password: _passwordController.text,
                          ));

                          context.goNamed("home");
                        }
                      },
                      child: const Text("Login"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => context.goNamed("signup"),
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
    );
  }
}
