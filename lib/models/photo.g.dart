// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['label']);
  return Photo(
    json['albumId'] as int,
  )..label = json['label'] as String;
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'albumId': instance.albumId,
      'label': instance.label,
    };
