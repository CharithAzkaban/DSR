// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditItem _$CreditItemFromJson(Map<String, dynamic> json) => CreditItem(
      customerName: json['customerName'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$CreditItemToJson(CreditItem instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'amount': instance.amount,
    };
