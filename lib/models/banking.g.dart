// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Banking _$BankingFromJson(Map<String, dynamic> json) => Banking(
      dsr_id: json['dsr_id'] as int,
      bankings: (json['bankings'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$BankingToJson(Banking instance) => <String, dynamic>{
      'dsr_id': instance.dsr_id,
      'bankings': instance.bankings,
      'date': instance.date,
    };
