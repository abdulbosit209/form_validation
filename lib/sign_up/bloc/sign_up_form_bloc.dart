import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:forms_validation/repository.dart';
import 'package:forms_validation/sign_up/models/confirm_password.dart';
import 'package:forms_validation/sign_up/models/email.dart';
import 'package:forms_validation/sign_up/models/strong_password.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';

part 'sign_up_form_event.dart';
part 'sign_up_form_state.dart';

EventTransformer<RegistrationEvent> debounceRestartable<RegistrationEvent>({
  Duration duration = const Duration(microseconds: 300),
}) {
  return (events, mapper) =>
      restartable<RegistrationEvent>().call(events.debounce(duration), mapper);
}

class SignUpFormBloc extends Bloc<SignUpFormEvent, SignUpFormState> {
  SignUpFormBloc({required Repository repository})
    : _repository = repository,
      super(SignUpFormState()) {
    on<EmailChanged>(_emailChanged, transformer: debounceRestartable());
    on<PasswordChanged>(_passwordChanged);
    on<ConfirmPasswordChanged>(_confirmPasswordChanged);
    on<Submit>(_submit);
  }

  final Repository _repository;

  Future<void> _submit(
    Submit event,
    Emitter<SignUpFormState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _repository.submit();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(state.copyWith(status: FormzSubmissionStatus.failure, error: () => error.toString()));
    }
  }

  void _confirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<SignUpFormState> emit,
  ) {
    final confirmPassword = ConfirmPassword.dirty(
      original: state.password,
      value: event.confirmPassword,
    );
    emit(state.copyWith(confirmPassword: confirmPassword));
  }

  void _passwordChanged(
    PasswordChanged event,
    Emitter<SignUpFormState> emit,
  ) {
    final password = StrongPassword.dirty(event.password);
    final confirmPassword = ConfirmPassword.dirty(
      original: password,
      value: state.confirmPassword.value,
    );
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        password: password,
      ),
    );
  }

  Future<void> _emailChanged(
    EmailChanged event,
    Emitter<SignUpFormState> emit,
  ) async {
    var email = Email.dirty(value: event.email);

    emit(
      state.copyWith(
        email: email,
        isCheckingUsername: email.isValid,
      ),
    );

    if (email.isValid) {
      final isUsernameAvailable = await _checkEmailAvailability(email: email.value);
      if (!isUsernameAvailable) {
        email = Email.dirty(
          value: event.email,
          serverError: EmailValidationError.taken,
        );
      }
      return emit(
        state.copyWith(
          email: email,
          isCheckingUsername: false,
        ),
      );
    }
  }

  Future<bool> _checkEmailAvailability({required String email}) async {
    try {
      await _repository.checkEmailAvailability(email);
      return true;
    } catch (e) {
      return false;
    }
  }
}
