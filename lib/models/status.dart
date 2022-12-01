import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonSerializable()
class Status {
  final int inhand_sum;
  final int sales_sum;
  final int credit_sum;
  final int credit_collection_sum;
  final int banking_sum;
  final int direct_banking_sum;
  final int retialer_sum;

  Status({
    required this.inhand_sum,
    required this.sales_sum,
    required this.credit_sum,
    required this.credit_collection_sum,
    required this.banking_sum,
    required this.direct_banking_sum,
    required this.retialer_sum,
  });

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);

  /// Connect the generated [_$StatusToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$StatusToJson(this);
}
