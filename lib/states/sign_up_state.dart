import 'package:kazu_app/states/form_submission_status.dart';

class SignUpState {
  final String username;
  bool get isValidUsername => username.length > 3;
  final String email;
  bool get isValidEmail => email.length > 3;
  final String password;
  bool get isValidPassword => password.length > 8;
  final FormSubmissionStatus formStatus;

  SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}