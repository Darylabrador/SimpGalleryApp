// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['comment']);
  return Comment(
    json['userId'] as int,
    json['photoId'] as int,
  )..comment = json['comment'] as String;
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'photoId': instance.photoId,
      'userId': instance.userId,
      'comment': instance.comment,
    };
