// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direct_banking_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectBankingItem _$DirectBankingItemFromJson(Map<String, dynamic> json) =>
    DirectBankingItem(
      customerName: json['customerName'] as String,
      bank: json['bank'] as String,
      refno: json['refno'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$DirectBankingItemToJson(DirectBankingItem instance) =>
    <String, dynamic>{
      'customerName': instance.customerName,
      'bank': instance.bank,
      'refno': instance.refno,
      'amount': instance.amount,
    };
