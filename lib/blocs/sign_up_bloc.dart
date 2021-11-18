import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/cubit/auth_cubit.dart';
import 'package:kazu_app/events/login_event.dart';
import 'package:kazu_app/events/sign_up_event.dart';
import 'package:kazu_app/repositories/auth_repository.dart';
import 'package:kazu_app/states/form_submission_status.dart';
import 'package:kazu_app/states/login_state.dart';
import 'package:kazu_app/states/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;
  final AuthCubit authCubit;

  SignUpBloc({required this.authRepository, required this.authCubit}) : super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async*{
    if (event is SignUpUsernameChanged) {
      yield state.copyWith(username: event.username);
    } else if (event is SignUpEmailChanged) {
      yield state.copyWith(email: event.email);
    } else if (event is SignUpPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is SignUpSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await authRepository.signUp(
            username: state.username,
            email: state.email,
            password: state.password
        );
        yield state.copyWith(formStatus: SubmissionSuccess());

        authCubit.showConfirmSignUp(
            username: state.username,
            email: state.email,
            password: state.password
        );

      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}