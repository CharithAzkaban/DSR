import 'package:dsr_app/models/cheque.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inhand.g.dart';

@JsonSerializable()
class Inhand {
  final int dsr_id;
  final double cash;
  final List<Cheque> cheques;
  final String date;

  Inhand({required this.dsr_id, required this.cash, required this.cheques, required this.date});

  factory Inhand.fromJson(Map<String, dynamic> json) => _$InhandFromJson(json);

  /// Connect the generated [_$InhandToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$InhandToJson(this);
}
