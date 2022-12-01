// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int,
      name: json['name'] as String,
      purchasing_price: json['purchasing_price'] as double,
      selling_price: json['selling_price'] as double,
      qty: json['qty'] as double,
      status: json['status'] as int,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'purchasing_price': instance.purchasing_price,
      'selling_price': instance.selling_price,
      'qty': instance.qty,
      'status': instance.status,
    };
