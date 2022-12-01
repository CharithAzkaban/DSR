// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      id: json['id'] as int,
      dsr_id: json['dsr_id'] as int,
      date: json['date'] as String,
      inhand_sum: (json['inhand_sum'] as num).toDouble(),
      sales_sum: (json['sales_sum'] as num).toDouble(),
      credit_sum: (json['credit_sum'] as num).toDouble(),
      credit_collection_sum: (json['credit_collection_sum'] as num).toDouble(),
      banking_sum: (json['banking_sum'] as num).toDouble(),
      direct_banking_sum: (json['direct_banking_sum'] as num).toDouble(),
      retialer_item_count: (json['retialer_item_count'] as num).toDouble(),
    );

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
      'id': instance.id,
      'dsr_id': instance.dsr_id,
      'date': instance.date,
      'inhand_sum': instance.inhand_sum,
      'sales_sum': instance.sales_sum,
      'credit_sum': instance.credit_sum,
      'credit_collection_sum': instance.credit_collection_sum,
      'banking_sum': instance.banking_sum,
      'direct_banking_sum': instance.direct_banking_sum,
      'retialer_item_count': instance.retialer_item_count,
    };
