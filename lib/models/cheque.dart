import 'package:json_annotation/json_annotation.dart';

part 'cheque.g.dart';

@JsonSerializable()
class Cheque {
  final String cheque_no;
  final double cheque_amount;

  Cheque({required this.cheque_no, required this.cheque_amount,});

  factory Cheque.fromJson(Map<String, dynamic> json) => _$ChequeFromJson(json);

  Map<String, dynamic> toJson() => _$ChequeToJson(this);
}
