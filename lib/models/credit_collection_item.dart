import 'package:json_annotation/json_annotation.dart';

part 'credit_collection_item.g.dart';

@JsonSerializable()
class CreditCollectionItem {
  final String ccName;
  final double ccAmount;

  CreditCollectionItem({
    required this.ccName,
    required this.ccAmount,
  });

  factory CreditCollectionItem.fromJson(Map<String, dynamic> json) =>
      _$CreditCollectionItemFromJson(json);

  /// Connect the generated [_$CreditCollectionItemToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CreditCollectionItemToJson(this);
}
