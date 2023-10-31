import 'package:equatable/equatable.dart';

class MemberModel extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String memberType;

  const MemberModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.memberType,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      memberType: json['memberType'],
    );
  }

  @override
  List<Object?> get props => [id, name, email, password, memberType];
}
