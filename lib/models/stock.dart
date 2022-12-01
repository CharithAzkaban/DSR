import 'package:json_annotation/json_annotation.dart';

part 'stock.g.dart';

@JsonSerializable()
class Stock {
  final int stock_id;
  final double qty;

  Stock({
    required this.stock_id,
    required this.qty,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => _$StockFromJson(json);

  /// Connect the generated [_$StockToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$StockToJson(this);
}
