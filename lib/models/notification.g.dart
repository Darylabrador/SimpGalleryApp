// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['label', 'isRead']);
  return Notification(
    json['userId'] as String,
  )
    ..label = json['label'] as String
    ..isRead = json['isRead'] as bool;
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'label': instance.label,
      'isRead': instance.isRead,
    };
