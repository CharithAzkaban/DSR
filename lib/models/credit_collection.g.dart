// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCollection _$CreditCollectionFromJson(Map<String, dynamic> json) =>
    CreditCollection(
      dsr_id: json['dsr_id'] as int,
      creditcollections: (json['creditcollections'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$CreditCollectionToJson(CreditCollection instance) =>
    <String, dynamic>{
      'dsr_id': instance.dsr_id,
      'creditcollections': instance.creditcollections,
      'date': instance.date,
    };
