import 'package:json_annotation/json_annotation.dart';

part 'return_item.g.dart';

@JsonSerializable()
class ReturnItem {
  final String reCustomerName;
  final int reitemId;
  final double reQuantity;
  final double reAmount;

  ReturnItem({
    required this.reCustomerName,
    required this.reitemId,
    required this.reQuantity,
    required this.reAmount,
  });

  factory ReturnItem.fromJson(Map<String, dynamic> json) =>
      _$ReturnItemFromJson(json);

  /// Connect the generated [_$ReturnItemToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ReturnItemToJson(this);
}
