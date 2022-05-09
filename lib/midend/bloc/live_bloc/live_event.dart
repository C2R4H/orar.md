part of 'live_bloc.dart';

class LiveEvent{}

class LiveShowOrar extends LiveEvent{
  double currentTime;
  OrarModel orarModel;
  LiveShowOrar(this.orarModel,this.currentTime);
}

class LiveLoadRefresh extends LiveEvent{}
