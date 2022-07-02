part of "./user.dart";

@immutable
abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoadInProgress extends UserState {
  const UserLoadInProgress();
}

class UserLoadSuccess extends UserState {
  final User user;

  const UserLoadSuccess({
    required this.user,
  });
}

class UserLoadFailure extends UserState {
  final List<String> error;
  final String userNameOrEmail;
  final String password;

  const UserLoadFailure({
    required this.error,
    required this.userNameOrEmail,
    required this.password,
  });
}

@immutable
abstract class UserEvent {
  const UserEvent();
}

class UserLoggedIn extends UserEvent {
  final String userNameOrEmail;
  final String password;

  const UserLoggedIn({
    required this.userNameOrEmail,
    required this.password,
  });
}

class UserSignedUp extends UserEvent {
  final String userName;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? nameSuffix;

  const UserSignedUp({
    required this.userName,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.nameSuffix,
  });
}

class UserLoggedOut extends UserEvent {
  const UserLoggedOut();
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(const UserInitial()) {
    on<UserLoggedIn>((event, emit) async {
      emit(const UserLoadInProgress());
      final user =
          await _userRepository.findByEmailOrUserName(event.userNameOrEmail);

      if (user == null) {
        emit(UserLoadFailure(
          error: const ["User not found"],
          userNameOrEmail: event.userNameOrEmail,
          password: event.password,
        ));
      } else {
        emit(UserLoadSuccess(user: user));
      }
    });

    on<UserSignedUp>((event, emit) async {
      emit(const UserLoadInProgress());
      final user = User(
        account: Account(
          userName: event.userName,
          email: event.email,
          password: event.password,
        ),
        profile: Profile(
          firstName: event.firstName,
          lastName: event.lastName,
          middleName: event.middleName,
          nameSuffix: event.nameSuffix,
        ),
      );
      try {
        await _userRepository.saveUser(user);
      } on Exception {}
    });

    on<UserLoggedOut>((event, emit) {
      emit(const UserInitial());
    });
  }
}
