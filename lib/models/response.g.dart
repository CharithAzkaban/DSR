// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Respo _$RespoFromJson(Map<String, dynamic> json) => Respo(
      info: json['data']['info'] == null
          ? null
          : User.fromJson(json['data']['info'][0] as Map<String, dynamic>),
      error: json['error'] as int?,
    );

Map<String, dynamic> _$RespoToJson(Respo instance) => <String, dynamic>{
      'info': instance.info,
      'error': instance.error,
    };
