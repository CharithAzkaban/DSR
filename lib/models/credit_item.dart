import 'package:json_annotation/json_annotation.dart';

part 'credit_item.g.dart';

@JsonSerializable()
class CreditItem {
  final String customerName;
  final double amount;

  CreditItem({
    required this.customerName,
    required this.amount,
  });

  factory CreditItem.fromJson(Map<String, dynamic> json) =>
      _$CreditItemFromJson(json);

  Map<String, dynamic> toJson() => _$CreditItemToJson(this);
}
