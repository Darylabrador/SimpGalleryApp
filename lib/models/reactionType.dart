import 'package:json_annotation/json_annotation.dart';

part 'reactionType.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class ReactionType {
  ReactionType(this.label, this.icone);

  @JsonKey(required: true)
  String label;

  @JsonKey(required: true)
  String icone;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$ReactionTypeFromJson(json)` constructor.
  /// The constructor is named after the source class, in this case, Album.
  factory ReactionType.fromJson(Map<String, dynamic> json) =>
      _$ReactionTypeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ReactionTypeToJson`.
  Map<String, dynamic> toJson() => _$ReactionTypeToJson(this);
}
