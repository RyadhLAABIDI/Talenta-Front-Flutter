part of 'user.dart';

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
    );
