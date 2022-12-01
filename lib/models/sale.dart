import 'package:json_annotation/json_annotation.dart';

part 'sale.g.dart';

@JsonSerializable()
class Sale {
  Sale({
    required this.dsr_id,
    required this.sales,
    required this.date,
  });

  int dsr_id;
  List<Map<String, dynamic>> sales;
  String date;

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

  /// Connect the generated [_$SaleToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SaleToJson(this);
}
