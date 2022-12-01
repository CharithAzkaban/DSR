import 'package:json_annotation/json_annotation.dart';

part 'banking_item.g.dart';

@JsonSerializable()
class BankingItem {
  final int bank_id;
  final String ref_no;
  final double amount;

  BankingItem({
    required this.bank_id,
    required this.ref_no,
    required this.amount,
  });

  factory BankingItem.fromJson(Map<String, dynamic> json) =>
      _$BankingItemFromJson(json);

  Map<String, dynamic> toJson() => _$BankingItemToJson(this);
}
