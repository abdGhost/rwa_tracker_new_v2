class LoginResponse {
  final bool status;
  final String message;
  final String id;
  final String name;
  final String token;
  final String email;

  LoginResponse({
    required this.status,
    required this.message,
    required this.id,
    required this.name,
    required this.token,
    required this.email,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      id: json['_id'],
      name: json['name'],
      token: json['token'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      '_id': id,
      'name': name,
      'token': token,
      'email': email,
    };
  }
}
