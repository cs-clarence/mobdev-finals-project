part of "./user.dart";

abstract class UserRepository {
  Future<User?> findByEmailOrUserName(String userNameOrEmail);
  Future<void> saveUser(User user);
}

abstract class UserRepositoryExceptions implements Exception {
  UserRepositoryExceptions(String message);
}

class UserNameAlreadyTakenException extends UserRepositoryExceptions {
  UserNameAlreadyTakenException(String userName)
      : super("User name $userName is already taken");
}

class UserEmailAlreadyTakenException extends UserRepositoryExceptions {
  UserEmailAlreadyTakenException(String email)
      : super("Email $email is already taken");
}

class WebApiUserRepository extends UserRepository {
  @override
  Future<User?> findByEmailOrUserName(String userNameOrEmail) {
    // TODO: implement findByEmailOrUserName
    throw UnimplementedError();
  }

  @override
  Future<void> saveUser(User user) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }
}
