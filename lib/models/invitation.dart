import 'package:json_annotation/json_annotation.dart';

part 'invitation.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Invitation {
  Invitation(this.target, this.albumId);

  @JsonKey(required: true)
  String target;

  @JsonKey(required: false)
  int albumId;

  @JsonKey(required: true)
  late bool isMobile;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$InvitationFromJson(json)` constructor.
  /// The constructor is named after the source class, in this case, Album.
  factory Invitation.fromJson(Map<String, dynamic> json) =>
      _$InvitationFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$InvitationToJson`.
  Map<String, dynamic> toJson() => _$InvitationToJson(this);
}
