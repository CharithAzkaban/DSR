// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReturnItem _$ReturnItemFromJson(Map<String, dynamic> json) => ReturnItem(
      reCustomerName: json['reCustomerName'] as String,
      reitemId: json['reitemId'] as int,
      reQuantity: (json['reQuantity'] as num).toDouble(),
      reAmount: (json['reAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$ReturnItemToJson(ReturnItem instance) =>
    <String, dynamic>{
      'reCustomerName': instance.reCustomerName,
      'reitemId': instance.reitemId,
      'reQuantity': instance.reQuantity,
      'reAmount': instance.reAmount,
    };
