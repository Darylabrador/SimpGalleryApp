// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['label']);
  return Album()
    ..userId = json['userId'] as int
    ..label = json['label'] as String
    ..cover = json['cover'] as String
    ..shareToken = json['shareToken'] as String
    ..shareAt = json['shareAt'] as String;
}

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'userId': instance.userId,
      'label': instance.label,
      'cover': instance.cover,
      'shareToken': instance.shareToken,
      'shareAt': instance.shareAt,
    };
