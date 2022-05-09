import 'perechiSunet_model.dart';

class LectieModel{
  int perecheId;
  String perecheNume;

  String startingTime; 
  String endingTime;

  String profesorNume;
  LectieModel({required this.perecheNume,required this.profesorNume,required this.perecheId,required this.startingTime,required this.endingTime}){
  }
}
