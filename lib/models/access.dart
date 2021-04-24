import 'package:json_annotation/json_annotation.dart';

part 'access.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Access {
  Access(this.userId, this.albumId);

  @JsonKey(required: false)
  int userId;

  @JsonKey(required: false)
  int albumId;

  @JsonKey(required: false)
  late String shareToken;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$AccessFromJson(json)` constructor.
  /// The constructor is named after the source class, in this case, Album.
  factory Access.fromJson(Map<String, dynamic> json) => _$AccessFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AccessToJson`.
  Map<String, dynamic> toJson() => _$AccessToJson(this);
}
