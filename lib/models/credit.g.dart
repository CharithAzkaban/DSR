// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credit _$CreditFromJson(Map<String, dynamic> json) => Credit(
      dsr_id: json['dsr_id'] as int,
      credits: (json['credits'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$CreditToJson(Credit instance) => <String, dynamic>{
      'dsr_id': instance.dsr_id,
      'credits': instance.credits,
      'date': instance.date,
    };
