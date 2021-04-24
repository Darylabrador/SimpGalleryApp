import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class Notification {
  Notification(this.userId);

  @JsonKey(required: false)
  String userId;

  @JsonKey(required: true)
  late String label;

  @JsonKey(required: true)
  late bool isRead;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$InvitationFromJson(json)` constructor.
  /// The constructor is named after the source class, in this case, Album.
  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$NotificationToJson`.
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
