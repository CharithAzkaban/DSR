// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Return _$ReturnFromJson(Map<String, dynamic> json) => Return(
      dsr_id: json['dsr_id'] as int,
      retilers: (json['retilers'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$ReturnToJson(Return instance) => <String, dynamic>{
      'dsr_id': instance.dsr_id,
      'retilers': instance.retilers,
      'date': instance.date,
    };
