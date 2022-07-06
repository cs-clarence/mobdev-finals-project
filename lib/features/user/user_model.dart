part of "./user.dart";

@JsonSerializable()
@immutable
class AccountModel {
  final String userName;
  final String email;
  final String password;
  final int accessLevel;

  const AccountModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.accessLevel,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}

@JsonSerializable()
@immutable
class ProfileModel {
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? nameSuffix;

  const ProfileModel({
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.nameSuffix,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

@immutable
class UserModel {
  final AccountModel account;
  final ProfileModel profile;

  const UserModel({
    required this.account,
    required this.profile,
  });
}
