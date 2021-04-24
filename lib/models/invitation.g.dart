// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invitation _$InvitationFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['target', 'isMobile']);
  return Invitation(
    json['target'] as String,
    json['albumId'] as int,
  )..isMobile = json['isMobile'] as bool;
}

Map<String, dynamic> _$InvitationToJson(Invitation instance) =>
    <String, dynamic>{
      'target': instance.target,
      'albumId': instance.albumId,
      'isMobile': instance.isMobile,
    };
