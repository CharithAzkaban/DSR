import 'package:json_annotation/json_annotation.dart';

part 'direct_banking.g.dart';

@JsonSerializable()
class DirectBanking {
  final int dsr_id;
  final List<Map<String, dynamic>> dbankings;
  final String date;

  DirectBanking({
    required this.dsr_id,
    required this.dbankings,
    required this.date
  });

  factory DirectBanking.fromJson(Map<String, dynamic> json) =>
      _$DirectBankingFromJson(json);

  /// Connect the generated [_$DirectBankingToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$DirectBankingToJson(this);
}
