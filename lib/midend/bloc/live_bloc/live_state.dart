part of 'live_bloc.dart';

class LiveState{}

class LiveStateShowCurrentOrar extends LiveState{

  List<LectieModel>? beforeLessons;
  LectieModel? currentLessons;
  List<LectieModel>? afterLessons;
  String? elapsedTime;
  String? remainingTime;
  LiveStateShowCurrentOrar({this.elapsedTime,this.beforeLessons,this.afterLessons,this.currentLessons,this.remainingTime});
}

class LiveStateLoading extends LiveState{}


