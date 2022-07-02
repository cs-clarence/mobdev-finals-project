part of "./user.dart";

@immutable
class Account {
  final String userName;
  final String email;
  final String password;

  const Account({
    required this.userName,
    required this.email,
    required this.password,
  });
}

@immutable
class Profile {
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? nameSuffix;
  const Profile({
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.nameSuffix,
  });
}

@immutable
class User {
  final Account account;
  final Profile profile;

  const User({
    required this.account,
    required this.profile,
  });
}
