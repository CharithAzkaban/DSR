// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Stock _$StockFromJson(Map<String, dynamic> json) => Stock(
      stock_id: json['stock_id'] as int,
      qty: (json['qty'] as num).toDouble(),
    );

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
      'stock_id': instance.stock_id,
      'qty': instance.qty,
    };
