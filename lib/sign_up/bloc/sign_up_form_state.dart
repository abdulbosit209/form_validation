part of 'sign_up_form_bloc.dart';

final class SignUpFormState extends Equatable{
  const SignUpFormState({
    this.email = const Email.pure(),
    this.password = const StrongPassword.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isCheckingEmail = false,
    this.error,
  });

  final Email email;
  final StrongPassword password;
  final ConfirmPassword confirmPassword;
  final bool isCheckingEmail;
  final FormzSubmissionStatus status;

  final String? error;

  bool get isPure => Formz.isPure([email, password, confirmPassword]);

  bool get isLoading => isValid && !status.isInProgress;

  SignUpFormState copyWith({
    Email? email,
    StrongPassword? password,
    ConfirmPassword? confirmPassword,
    FormzSubmissionStatus? status,
    bool? isCheckingEmail,
    String? Function()? error,
  }) {
    return SignUpFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      isCheckingEmail: isCheckingEmail ?? this.isCheckingEmail,
      error: error != null ? error() : this.error,
    );
  }

  bool get isValid => Formz.validate([email, password, confirmPassword]);

  @override
  List<Object?> get props => [status, email, password, confirmPassword, error, isCheckingEmail];

  @override
  String toString() {
    return 'SignUpFormState(email: $email, password: $password, confirmPassword: $confirmPassword, status: $status, isCheckingEmail: $isCheckingEmail, error: $error)';
  }
}
