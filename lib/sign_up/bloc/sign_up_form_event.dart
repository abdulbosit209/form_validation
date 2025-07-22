part of 'sign_up_form_bloc.dart';

@immutable
sealed class SignUpFormEvent {}

final class EmailChanged extends SignUpFormEvent {
  EmailChanged({required this.email});

  final String email;
}


final class PasswordChanged extends SignUpFormEvent {
  PasswordChanged({required this.password});

  final String password;
}

final class ConfirmPasswordChanged extends SignUpFormEvent {
  ConfirmPasswordChanged({required this.confirmPassword});

  final String confirmPassword;
}

final class Submit extends SignUpFormEvent {}
