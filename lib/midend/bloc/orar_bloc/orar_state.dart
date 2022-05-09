part of 'orar_bloc.dart';

class OrarState{}

class OrarStateLoading extends OrarState{}

class OrarStateLoadedData extends OrarState{
  OrarModel orar;
  List<PerechiSunetTime> perechiSunet;
  OrarStateLoadedData(this.orar,this.perechiSunet);
}

class OrarStateError extends OrarState{
  String error;
  OrarStateError(this.error);
}
