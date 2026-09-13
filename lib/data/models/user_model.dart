import '../../domain/entities/user.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final company = json['company'] as Map<String, dynamic>? ?? {};
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown user',
      email: json['email'] as String? ?? '',
      company: company['name'] as String? ?? '',
    );
  }

  final int id;
  final String name;
  final String email;
  final String company;

  User toEntity() => User(
        id: id,
        name: name,
        email: email,
        company: company,
      );
}