// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map<String, dynamic> json) {
  return Reaction(
    json['userId'] as int,
    json['photoId'] as int,
    json['reactionTypesId'] as int,
  );
}

Map<String, dynamic> _$ReactionToJson(Reaction instance) => <String, dynamic>{
      'userId': instance.userId,
      'photoId': instance.photoId,
      'reactionTypesId': instance.reactionTypesId,
    };
