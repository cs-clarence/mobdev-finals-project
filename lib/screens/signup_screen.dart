import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import '../features/user/user.dart';

class SignupScreen extends StatelessWidget {
  final UserBloc _userBloc;
  const SignupScreen({Key? key, required UserBloc userBloc})
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
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "CREATE AN ACCOUNT",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      validator: (value) =>
                          value != null ? null : "Username is required",
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      validator: (value) =>
                          value != null ? null : "Username is required",
                      decoration: const InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        context.goNamed("home");
                      },
                      child: const Text("Signup"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () => context.goNamed("login"),
                          child: const Text("Login"),
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
