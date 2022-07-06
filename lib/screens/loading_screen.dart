import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 96,
              child: Image.asset("assets/images/logo.png"),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              "PC Parts List",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              "Created by Clarence Manuel",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              height: 32,
            ),
            const CircularProgressIndicator(),
            const SizedBox(
              height: 8,
            ),
            const Text("Loading..."),
          ],
        ),
      ),
    );
  }
}
