import 'package:json_annotation/json_annotation.dart';

part 'sale_item.g.dart';

@JsonSerializable()
class SaleItem {
  SaleItem({
    required this.dsrStockIds,
    required this.itemId,
    required this.itemName,
    required this.itemQty,
    required this.itemPrice,
  });

  List<Map<String,dynamic>> dsrStockIds;
  int itemId;
  String itemName;
  double itemQty;
  double itemPrice;

  factory SaleItem.fromJson(Map<String, dynamic> json) => _$SaleItemFromJson(json);

  /// Connect the generated [_$SaleItemToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SaleItemToJson(this);
}
