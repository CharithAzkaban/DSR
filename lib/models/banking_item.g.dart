// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banking_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankingItem _$BankingItemFromJson(Map<String, dynamic> json) => BankingItem(
      bank_id: json['bank_id'] as int,
  ref_no: json['ref_no'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$BankingItemToJson(BankingItem instance) =>
    <String, dynamic>{
      'bank_id': instance.bank_id,
      'ref_no': instance.ref_no,
      'amount': instance.amount,
    };
