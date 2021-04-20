import 'package:json_annotation/json_annotation.dart';

part 'album.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Album {
  Album(this.userId, this.id, this.title);

  @JsonKey(required: true)
  int userId;

  @JsonKey(required: true)
  int id;

  @JsonKey(required: true)
  String title;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson(json)` constructor.
  /// The constructor is named after the source class, in this case, Album.
  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AlbumToJson`.
  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
