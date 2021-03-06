import 'package:json_annotation/json_annotation.dart';

part 'album.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Album {
  Album();

  @JsonKey(required: false)
  late int userId;

  @JsonKey(required: true)
  late String label;

  @JsonKey(required: false)
  late String cover;

  @JsonKey(required: false)
  late String shareToken;

  @JsonKey(required: false)
  late String shareAt;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$AlbumFromJson(json)` constructor.
  /// The constructor is named after the source class, in this case, Album.
  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AlbumToJson`.
  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
