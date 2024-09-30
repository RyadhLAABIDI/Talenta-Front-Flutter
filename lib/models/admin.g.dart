// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Admin _$AdminFromJson(Map<String, dynamic> json) {
  return Admin(
    email: json['email'] as String,
    role: json['role'] as String,
  );
}

Map<String, dynamic> _$AdminToJson(Admin instance) => <String, dynamic>{
      'email': instance.email,
      'role': instance.role,
    };
