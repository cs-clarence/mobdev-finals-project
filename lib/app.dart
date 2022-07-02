import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import "./router.dart";
import 'features/user/user.dart';

@immutable
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => WebApiUserRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(context.read<UserRepository>()),
          )
        ],
        child: Builder(
          builder: (context) {
            final router = buildRouter(context);

            return MaterialApp.router(
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              routeInformationProvider: router.routeInformationProvider,
              themeMode: ThemeMode.system,
              theme: ThemeData.light().copyWith(useMaterial3: true),
              darkTheme: ThemeData.dark().copyWith(useMaterial3: true),
              title: "PC Parts List",
            );
          },
        ),
      ),
    );
  }
}
