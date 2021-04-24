import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Photo {
  Photo(this.albumId);

  @JsonKey(required: false)
  int albumId;

  @JsonKey(required: true)
  late String label;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$InvitationFromJson(json)` constructor.
  /// The constructor is named after the source class, in this case, Album.
  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$NotificationToJson`.
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
