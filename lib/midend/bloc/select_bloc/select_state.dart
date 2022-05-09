part of 'select_bloc.dart';

class SelectState{}

class SelectStateLoading extends SelectState{}

class SelectStateColegiiLoaded extends SelectState{
  List<ColegiuModel> colegiuModelList;
  SelectStateColegiiLoaded(this.colegiuModelList);
}

class SelectStateChoosedColegiu extends SelectState{
  ColegiuModel colegiuModel;
  SelectStateChoosedColegiu(this.colegiuModel);
}

class SelectStateChoosedGroup extends SelectState{
  OrarModel orarGrupa;
  ColegiuModel colegiuModel;
  String grupaName;
  SelectStateChoosedGroup(this.orarGrupa,this.colegiuModel,this.grupaName);
}

