// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactionType.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionType _$ReactionTypeFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['label', 'icone']);
  return ReactionType(
    json['label'] as String,
    json['icone'] as String,
  );
}

Map<String, dynamic> _$ReactionTypeToJson(ReactionType instance) =>
    <String, dynamic>{
      'label': instance.label,
      'icone': instance.icone,
    };
