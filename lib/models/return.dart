import 'package:json_annotation/json_annotation.dart';

part 'return.g.dart';

@JsonSerializable()
class Return {
  final int dsr_id;
  final List<Map<String, dynamic>> retilers;
  final String date;

  Return({
    required this.dsr_id,
    required this.retilers,
    required this.date
  });

  factory Return.fromJson(Map<String, dynamic> json) => _$ReturnFromJson(json);

  /// Connect the generated [_$ReturnToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ReturnToJson(this);
}
