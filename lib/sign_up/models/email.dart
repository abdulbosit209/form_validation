import 'package:formz/formz.dart';

enum EmailValidationError { empty, invalid, taken }

class Email extends FormzInput<String, EmailValidationError> {
  /// {@macro email}
  const Email.pure({String value = '', this.serverError}) : super.pure(value);

  /// {@macro email}
  const Email.dirty({String value = '', this.serverError}) : super.dirty(value);

  static final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  final EmailValidationError? serverError;

  @override
  EmailValidationError? validator(String? value) {
    final error = serverError;
    if (error != null) return error;
    if (value == null || value.isEmpty) {
      return EmailValidationError.empty;
    }
    if (!_emailRegExp.hasMatch(value)) {
      return EmailValidationError.invalid;
    }
    return null;
  }
}

extension EmailValidationErrorX on EmailValidationError {
  String message() {
    switch (this) {
      case EmailValidationError.invalid:
        return 'Please ensure the email entered is valid';
      case EmailValidationError.empty:
        return 'Please enter an email';
      case EmailValidationError.taken:
        return 'Email already taken';
    }
  }
}
