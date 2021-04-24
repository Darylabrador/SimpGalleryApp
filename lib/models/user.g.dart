// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'pseudo',
    'identifiant',
    'profilPic',
    'isMobile',
    'email',
    'password'
  ]);
  return User(
    json['email'] as String,
    json['password'] as String,
  )
    ..pseudo = json['pseudo'] as String
    ..identifiant = json['identifiant'] as String
    ..profilPic = json['profilPic'] as String
    ..isMobile = json['isMobile'] as bool
    ..resetToken = json['resetToken'] as String
    ..verifyAt = DateTime.parse(json['verifyAt'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'pseudo': instance.pseudo,
      'identifiant': instance.identifiant,
      'profilPic': instance.profilPic,
      'isMobile': instance.isMobile,
      'resetToken': instance.resetToken,
      'verifyAt': instance.verifyAt.toIso8601String(),
      'email': instance.email,
      'password': instance.password,
    };
