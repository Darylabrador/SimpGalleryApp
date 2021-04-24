import 'package:json_annotation/json_annotation.dart';

part 'reaction.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Reaction {
  Reaction(this.userId, this.photoId, this.reactionTypesId);

  @JsonKey(required: false)
  int userId;

  @JsonKey(required: false)
  int photoId;

  @JsonKey(required: false)
  int reactionTypesId;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$ReactionFromJson(json)` constructor.
  /// The constructor is named after the source class, in this case, Album.
  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ReactionToJson`.
  Map<String, dynamic> toJson() => _$ReactionToJson(this);
}
