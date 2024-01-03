import 'package:async/async.dart';
import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:food_order_app/cache/local_store_contract.dart';
import 'package:food_order_app/models/user.dart';
import 'package:food_order_app/states_management/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ILocalStore localStore;
  AuthCubit(this.localStore) : super(InitialState());
  signin(IAuthService authService, AuthType type) async {
    _startLoading();
    final result = await authService.signIn();
    localStore.saveAuthType(type);
    _setResultofAuthState(result);
  }

  signout(IAuthService authService) async {
    _startLoading();
    final token = await localStore.fetch();
    final result = await authService.signOut(token);
    if (result.asValue!.value) {
      localStore.delete(token);
      emit(SignOutSuccessState());
    } else {
      emit(ErrorState("Error Signing out"));
    }
  }

  signup(ISignUpService signupService, User user) async {
    _startLoading();
    final result = await signupService.signup(
      user.name,
      user.email,
      user.password,
    );
    _setResultofAuthState(result);
  }

  void _setResultofAuthState(Result<Token> result) {
    if (result.asError != null) {
      emit(ErrorState(result.asError!.error.toString()));
    } else {
      localStore.save(result.asValue!.value);
      emit(AuthSuccessState(result.asValue!.value));
    }
  }

  void _startLoading() => emit(LoadingState());
}
