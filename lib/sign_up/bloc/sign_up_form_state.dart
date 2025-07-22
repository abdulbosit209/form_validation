part of 'sign_up_form_bloc.dart';

class SignUpFormState extends Equatable{
  const SignUpFormState({
    this.email = const Email.pure(),
    this.password = const StrongPassword.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isCheckingUsername = false,
    this.error,
  });

  final Email email;
  final StrongPassword password;
  final ConfirmPassword confirmPassword;
  final FormzSubmissionStatus status;
  final bool isCheckingUsername;
  final String? error;

  bool get isValid => Formz.validate([email, password, confirmPassword]);

  bool get isPure => Formz.validate([email, password, confirmPassword]);

  bool get isLoading => isValid && !status.isInProgress;

  SignUpFormState copyWith({
    Email? email,
    StrongPassword? password,
    ConfirmPassword? confirmPassword,
    FormzSubmissionStatus? status,
    bool? isCheckingUsername,
    String? Function()? error,
  }) {
    return SignUpFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      isCheckingUsername: isCheckingUsername ?? this.isCheckingUsername,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [status, email, password, confirmPassword, error, isCheckingUsername];

  @override
  String toString() {
    return 'SignUpFormState(email: $email, password: $password, confirmPassword: $confirmPassword, status: $status, isCheckingUsername: $isCheckingUsername, error: $error)';
  }
}
