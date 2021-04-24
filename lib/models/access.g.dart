// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Access _$AccessFromJson(Map<String, dynamic> json) {
  return Access(
    json['userId'] as int,
    json['albumId'] as int,
  )..shareToken = json['shareToken'] as String;
}

Map<String, dynamic> _$AccessToJson(Access instance) => <String, dynamic>{
      'userId': instance.userId,
      'albumId': instance.albumId,
      'shareToken': instance.shareToken,
    };
