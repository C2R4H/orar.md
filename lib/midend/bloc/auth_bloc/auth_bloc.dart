import 'package:flutter_bloc/flutter_bloc.dart';

import '../../user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc() : super(AuthState()){
    UserModel userModel = UserModel();

    on<AppStarted>((event, emit) async {
      emit(AuthStateLoading());
      await userModel.getData();
      if(userModel.isAuthenticated)
        emit(AuthStateAuthenticated(userModel));
      else
        emit(AuthStateUnaunthenticated(userModel));
    });
  }
}
