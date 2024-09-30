import 'package:json_annotation/json_annotation.dart';

part 'talent.g.dart';

@JsonSerializable()
class Talent {
  final String email;
  final String password;
  final String role;
  bool banned;

  Talent({
    required this.email,
    required this.password,
    required this.role,
    this.banned = false,
  });

  factory Talent.fromJson(Map<String, dynamic> json) => _$TalentFromJson(json);
  Map<String, dynamic> toJson() => _$TalentToJson(this);
}
