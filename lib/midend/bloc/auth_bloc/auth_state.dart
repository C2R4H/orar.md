part of 'auth_bloc.dart';


class AuthState{
  const AuthState();
}

class AuthStateAuthenticated extends AuthState{
  UserModel userModel;
  AuthStateAuthenticated(this.userModel);
}

class AuthStateUnaunthenticated extends AuthState{
  UserModel userModel;
  AuthStateUnaunthenticated(this.userModel);
}

class AuthStateLoading extends AuthState{}

class AuthStateError extends AuthState{
  String message;
  AuthStateError(this.message);
}

