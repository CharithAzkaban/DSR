// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_collection_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditCollectionItem _$CreditCollectionItemFromJson(
        Map<String, dynamic> json) =>
    CreditCollectionItem(
      ccName: json['ccName'] as String,
      ccAmount: (json['ccAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$CreditCollectionItemToJson(
        CreditCollectionItem instance) =>
    <String, dynamic>{
      'ccName': instance.ccName,
      'ccAmount': instance.ccAmount,
    };
