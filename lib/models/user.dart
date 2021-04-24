import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class User {
  User(this.email, this.password);

  @JsonKey(required: true)
  late String pseudo;

  @JsonKey(required: true)
  late String identifiant;

  @JsonKey(required: true)
  late String profilPic;

  @JsonKey(required: true)
  late bool isMobile;

  @JsonKey(required: false)
  late String resetToken;

  @JsonKey(required: false)
  late DateTime verifyAt;

  @JsonKey(required: true)
  String email;

  @JsonKey(required: true)
  String password;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
