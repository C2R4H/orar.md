part of 'orar_bloc.dart';

class OrarEvent{}

class GetOrarData extends OrarEvent{
  UserModel userModel;
  GetOrarData(this.userModel);
}
