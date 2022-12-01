import 'package:json_annotation/json_annotation.dart';

part 'summary.g.dart';

@JsonSerializable()
class Summary {
  final int id;
  final int dsr_id;
  final String date;
  final double inhand_sum;
  final double sales_sum;
  final double credit_sum;
  final double credit_collection_sum;
  final double banking_sum;
  final double direct_banking_sum;
  final double retialer_item_count;

  Summary({
    required this.id,
    required this.dsr_id,
    required this.date,
    required this.inhand_sum,
    required this.sales_sum,
    required this.credit_sum,
    required this.credit_collection_sum,
    required this.banking_sum,
    required this.direct_banking_sum,
    required this.retialer_item_count,
  });

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  /// Connect the generated [_$SummaryToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$SummaryToJson(this);
}
