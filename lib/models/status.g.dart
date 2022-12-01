// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      inhand_sum: json['inhand_sum'] as int,
      sales_sum: json['sales_sum'] as int,
      credit_sum: json['credit_sum'] as int,
      credit_collection_sum: json['credit_collection_sum'] as int,
      banking_sum: json['banking_sum'] as int,
      direct_banking_sum: json['direct_banking_sum'] as int,
      retialer_sum: json['retialer_sum'] as int,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'inhand_sum': instance.inhand_sum,
      'sales_sum': instance.sales_sum,
      'credit_sum': instance.credit_sum,
      'credit_collection_sum': instance.credit_collection_sum,
      'banking_sum': instance.banking_sum,
      'direct_banking_sum': instance.direct_banking_sum,
      'retialer_sum': instance.retialer_sum,
    };
