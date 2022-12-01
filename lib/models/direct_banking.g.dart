// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direct_banking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectBanking _$DirectBankingFromJson(Map<String, dynamic> json) =>
    DirectBanking(
      dsr_id: json['dsr_id'] as int,
      dbankings: (json['dbankings'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$DirectBankingToJson(DirectBanking instance) =>
    <String, dynamic>{
      'dsr_id': instance.dsr_id,
      'dbankings': instance.dbankings,
      'date': instance.date,
    };
