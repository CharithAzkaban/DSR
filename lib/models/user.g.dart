// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String,
      nic: json['nic'] as String?,
      contact: json['contact'] as String?,
      route: json['route'] as String?,
      password: json['password'] as String,
      profile_photo_path: json['profile_photo_path'] as String?,
      status: json['status'] as int?,
      remember_token: json['remember_token'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'nic': instance.nic,
      'contact': instance.contact,
      'route': instance.route,
      'password': instance.password,
      'profile_photo_path': instance.profile_photo_path,
      'status': instance.status,
      'remember_token': instance.remember_token,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
    };
