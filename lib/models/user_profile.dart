import 'package:json_annotation/json_annotation.dart';
part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  String uid;
  String name;
  DateTime dob;

  UserProfile({required this.uid, required this.name, required this.dob});

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}