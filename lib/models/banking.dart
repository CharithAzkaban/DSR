import 'package:json_annotation/json_annotation.dart';

part 'banking.g.dart';

@JsonSerializable()
class Banking {
  final int dsr_id;
  final List<Map<String, dynamic>> bankings;
  final String date;

  Banking({
    required this.dsr_id,
    required this.bankings,
    required this.date
  });

  factory Banking.fromJson(Map<String, dynamic> json) =>
      _$BankingFromJson(json);

  /// Connect the generated [_$BankingToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BankingToJson(this);
}
