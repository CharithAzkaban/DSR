import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String name;
  final double purchasing_price;
  final double selling_price;
  final double qty;
  final int status;

  Product({
    required this.id,
    required this.name,
    required this.purchasing_price,
    required this.selling_price,
    required this.qty,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
