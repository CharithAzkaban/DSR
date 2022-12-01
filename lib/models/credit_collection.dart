import 'package:json_annotation/json_annotation.dart';

part 'credit_collection.g.dart';

@JsonSerializable()
class CreditCollection {
  final int dsr_id;
  final List<Map<String, dynamic>> creditcollections;
  final String date;

  CreditCollection({
    required this.dsr_id,
    required this.creditcollections,
    required this.date
  });

  factory CreditCollection.fromJson(Map<String, dynamic> json) =>
      _$CreditCollectionFromJson(json);

  /// Connect the generated [_$CreditCollectionToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CreditCollectionToJson(this);
}
