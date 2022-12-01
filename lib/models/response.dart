import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'response.g.dart';

@JsonSerializable()
class Respo {
  final User? info;
  final int? error;

  Respo({required this.info, required this.error});

  factory Respo.fromJson(Map<String, dynamic> json) => _$RespoFromJson(json);

  /// Connect the generated [_$RespoToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RespoToJson(this);
}
