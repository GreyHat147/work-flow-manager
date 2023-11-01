import 'package:equatable/equatable.dart';

class MemberModel extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String memberType;
  final double workedHours;

  const MemberModel({
    this.id,
    this.workedHours = 0,
    required this.name,
    required this.email,
    required this.password,
    required this.memberType,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return MemberModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      memberType: json['memberType'],
      workedHours: (json['workedHours'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'memberType': memberType,
      'workedHours': workedHours,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, email, password, memberType, workedHours];
}
