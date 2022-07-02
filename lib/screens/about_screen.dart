import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "About",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                Text(
                  "PC Parts List",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  "Created By Clarence D. Manuel",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 32),
                const CircleAvatar(
                  radius: 64,
                  backgroundImage:
                      AssetImage("assets/images/author_profile_picture.png"),
                ),
                const SizedBox(height: 8),
                Text(
                  "(Author)",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                TextButton(
                    onPressed: () => context.goNamed("home"),
                    child: const Text("Home")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
