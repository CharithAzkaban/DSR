import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String? name;
  final String email;
  final String? nic;
  final String? contact;
  final String? route;
  final String password;
  final String? profile_photo_path;
  final int? status;
  final String? remember_token;
  final DateTime? created_at;
  final DateTime? updated_at;

  User({this.id, this.name, required this.email, this.nic, this.contact, this.route, required this.password, this.profile_photo_path, this.status, this.remember_token, this.created_at, this.updated_at});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
