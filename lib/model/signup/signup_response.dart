// Model for Signup Response
class SignupResponse {
  final bool status;
  final String message;

  SignupResponse({
    required this.status,
    required this.message,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
