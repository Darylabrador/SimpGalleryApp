import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Comment {
  Comment(this.userId, this.photoId);

  @JsonKey(required: false)
  int photoId;

  @JsonKey(required: false)
  int userId;

  @JsonKey(required: true)
  late String comment;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$CommentFromJson(json)` constructor.
  /// The constructor is named after the source class, in this case, Album.
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$CommentToJson`.
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
