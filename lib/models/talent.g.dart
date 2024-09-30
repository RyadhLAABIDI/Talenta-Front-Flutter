part of 'talent.dart';

Map<String, dynamic> _$TalentToJson(Talent instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
    };

Talent _$TalentFromJson(Map<String, dynamic> json) => Talent(
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
    );
