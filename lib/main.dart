import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_validation/repository.dart';
import 'package:forms_validation/sign_up/bloc/sign_up_form_bloc.dart';
import 'package:forms_validation/sign_up/models/confirm_password.dart';
import 'package:forms_validation/sign_up/models/email.dart';
import 'package:forms_validation/sign_up/models/strong_password.dart';
import 'package:forms_validation/simple_bloc_observer.dart';
import 'package:formz/formz.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => Repository(),
      child: BlocProvider(
        create: (context) => SignUpFormBloc(
          repository: context.read<Repository>(),
        ),
        child: _AppView(),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formz Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpFormBloc, SignUpFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        if (state.status.isInProgress) {
          scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
        } else if (state.status.isSuccess) {
          scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Success')),
            );
        } else if (state.status.isFailure) {
          scaffoldMessenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.error ?? 'Sumbit error')),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text('Sign up'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              autovalidateMode: state.isPure ? AutovalidateMode.disabled : AutovalidateMode.always,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      errorText: state.email.displayError?.message(),
                      labelText: 'Email',
                      suffix: state.isCheckingUsername
                          ? ConstrainedBox(
                              constraints: BoxConstraints.tight(Size(15, 15)),
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )
                          : null,
                    ),
                    onChanged: (email) =>
                        context.read<SignUpFormBloc>().add(EmailChanged(email: email)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: state.password.displayError?.message(),
                    ),
                    onChanged: (password) {
                      context.read<SignUpFormBloc>().add(PasswordChanged(password: password));
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorText: state.confirmPassword.displayError?.message(),
                    ),
                    onChanged: (confirmPassword) {
                      context.read<SignUpFormBloc>().add(
                        ConfirmPasswordChanged(confirmPassword: confirmPassword),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? () => context.read<SignUpFormBloc>().add(Submit())
                        : null,
                    child: Text(
                      state.status.isInProgress ? 'Submitting' : 'Submit',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
