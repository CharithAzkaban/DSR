// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cheque.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cheque _$ChequeFromJson(Map<String, dynamic> json) => Cheque(
      cheque_no: json['cheque_no'] as String,
      cheque_amount: (json['cheque_amount'] as num).toDouble(),
    );

Map<String, dynamic> _$ChequeToJson(Cheque instance) => <String, dynamic>{
      'cheque_no': instance.cheque_no,
      'cheque_amount': instance.cheque_amount,
    };
