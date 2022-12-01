import 'package:json_annotation/json_annotation.dart';

part 'credit.g.dart';

@JsonSerializable()
class Credit {
  final int dsr_id;
  final List<Map<String, dynamic>> credits;
  final String date;

  Credit({
    required this.dsr_id,
    required this.credits,
    required this.date
  });

  factory Credit.fromJson(Map<String, dynamic> json) => _$CreditFromJson(json);

  /// Connect the generated [_$CreditToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CreditToJson(this);
}
