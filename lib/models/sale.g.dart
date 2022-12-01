// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sale _$SaleFromJson(Map<String, dynamic> json) => Sale(
      dsr_id: json['dsr_id'] as int,
      sales: (json['sales'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$SaleToJson(Sale instance) => <String, dynamic>{
      'dsr_id': instance.dsr_id,
      'sales': instance.sales,
      'date': instance.date,
    };
