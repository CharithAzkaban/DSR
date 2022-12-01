// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inhand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inhand _$InhandFromJson(Map<String, dynamic> json) => Inhand(
      dsr_id: json['dsr_id'] as int,
      cash: (json['cash'] as num).toDouble(),
      cheques: (json['cheques'] as List<dynamic>)
          .map((e) => Cheque.fromJson(e as Map<String, dynamic>))
          .toList(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$InhandToJson(Inhand instance) => <String, dynamic>{
      'dsr_id': instance.dsr_id,
      'cash': instance.cash,
      'cheques': instance.cheques,
      'date': instance.date,
    };
