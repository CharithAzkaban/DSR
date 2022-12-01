import 'package:json_annotation/json_annotation.dart';

part 'direct_banking_item.g.dart';

@JsonSerializable()
class DirectBankingItem {
  final String customerName;
  final String bank;
  final String refno;
  final double amount;

  DirectBankingItem({
    required this.customerName,
    required this.bank,
    required this.refno,
    required this.amount,
  });

  factory DirectBankingItem.fromJson(Map<String, dynamic> json) =>
      _$DirectBankingItemFromJson(json);

  /// Connect the generated [_$DirectBankingItemToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DirectBankingItemToJson(this);
}
