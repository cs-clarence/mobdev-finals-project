import "package:flutter/material.dart";
import "./app.dart";
import "package:go_router/go_router.dart";

void main() {
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  runApp(const App());
}
