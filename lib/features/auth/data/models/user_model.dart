class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>;
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: name['firstName'] as String,
      lastName: name['lastName'] as String,
      phone: json['phone']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': {
        'firstName': firstName,
        'lastName': lastName,
      },
      'phone': phone,
    };
  }
} 