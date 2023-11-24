import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class MemberModel extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String memberType;
  final double workedHours;
  List<String> projects = [];
  String? userUid;

  MemberModel({
    this.id,
    this.workedHours = 0,
    this.projects = const [],
    required this.name,
    required this.email,
    required this.password,
    required this.memberType,
    this.userUid,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      memberType: json['memberType'],
      workedHours: (json['workedHours'] as num).toDouble(),
      projects: List<String>.from(json['projects']),
      userUid: json['userUid'],
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
      'projects': projects,
      'userUid': userUid,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        memberType,
        workedHours,
        projects,
        userUid,
      ];
}
