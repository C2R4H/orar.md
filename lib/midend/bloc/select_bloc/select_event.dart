part of 'select_bloc.dart';

class SelectEvent{
}

class LoadColegii extends SelectEvent{
  String institution;
  LoadColegii(this.institution);
}

class LoadGroups extends SelectEvent{
  ColegiuModel colegiuModel;
  LoadGroups(this.colegiuModel);
}

class LoadOrar extends SelectEvent{
  String grupaName;
  String colegiuId;
  LoadOrar(this.grupaName,this.colegiuId);
}

