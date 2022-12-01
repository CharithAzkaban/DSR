// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleItem _$SaleItemFromJson(Map<String, dynamic> json) => SaleItem(
      dsrStockIds: (json['dsrStockIds'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      itemId: json['itemId'] as int,
      itemName: json['itemName'] as String,
      itemQty: (json['itemQty'] as num).toDouble(),
      itemPrice: (json['itemPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$SaleItemToJson(SaleItem instance) => <String, dynamic>{
      'dsrStockIds': instance.dsrStockIds,
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemQty': instance.itemQty,
      'itemPrice': instance.itemPrice,
    };
