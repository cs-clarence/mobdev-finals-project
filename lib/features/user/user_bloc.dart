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
  final UserModel user;

  const UserLoadSuccess({
    required this.user,
  });
}

class UserLoadFailure extends UserState {
  final List<String> errors;

  const UserLoadFailure({
    required this.errors,
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

class UserUpdated extends UserEvent {
  final String userName;
  final String? newUserName;
  final String? newEmail;
  final String? newPassword;
  final String? newFirstName;
  final String? newLastName;
  final String? newMiddleName;
  final String? newNameSuffix;

  const UserUpdated({
    required this.userName,
    this.newUserName,
    this.newEmail,
    this.newPassword,
    this.newFirstName,
    this.newLastName,
    this.newMiddleName,
    this.newNameSuffix,
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

      if (user == null || user.account.password != event.password) {
        emit(const UserLoadFailure(
          errors: ["Can't log in, check your credentials"],
        ));
      } else {
        emit(UserLoadSuccess(user: user));
      }
    });

    on<UserSignedUp>((event, emit) async {
      emit(const UserLoadInProgress());
      final user = UserModel(
        account: AccountModel(
          userName: event.userName,
          email: event.email,
          password: event.password,
          accessLevel: 0,
        ),
        profile: ProfileModel(
          firstName: event.firstName,
          lastName: event.lastName,
          middleName: event.middleName,
          nameSuffix: event.nameSuffix,
        ),
      );
      try {
        await _userRepository.save(
          email: user.account.email,
          firstName: user.profile.firstName,
          lastName: user.profile.firstName,
          nameSuffix: user.profile.nameSuffix,
          password: user.account.password,
          userName: user.account.userName,
          accessLevel: user.account.accessLevel,
          middleName: user.profile.middleName,
        );
        emit(UserLoadSuccess(user: user));
      } on UserRepositoryException catch (e) {
        emit(UserLoadFailure(
          errors: [e.message],
        ));
      }
    });

    on<UserLoggedOut>((event, emit) {
      emit(const UserInitial());
    });

    on<UserUpdated>((event, emit) async {
      emit(const UserLoadInProgress());
      try {
        await _userRepository.update(
          userName: event.userName,
          newPassword: event.newPassword,
          newNameSuffix: event.newNameSuffix,
          newMiddleName: event.newMiddleName,
          newLastName: event.newLastName,
          newFirstName: event.newFirstName,
          newEmail: event.newEmail,
          newUserName: event.newUserName,
        );
      } on UserRepositoryException catch (e) {
        emit(
          UserLoadFailure(
            errors: [e.message],
          ),
        );
      }

      final user = await _userRepository.findByUserName(
        event.newUserName ?? event.userName,
      );

      emit(UserLoadSuccess(user: user!));
    });
  }
}
