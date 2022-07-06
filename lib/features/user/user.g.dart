// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      userName: json['userName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      accessLevel: json['accessLevel'] as int? ?? 0,
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'email': instance.email,
      'password': instance.password,
      'accessLevel': instance.accessLevel,
    };

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      middleName: json['middleName'] as String?,
      nameSuffix: json['nameSuffix'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'nameSuffix': instance.nameSuffix,
    };
