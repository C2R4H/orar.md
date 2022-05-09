import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';

import '../../models/orar_model.dart';
import '../../models/lectie_model.dart';

part 'live_event.dart';
part 'live_state.dart';

class LiveBloc extends Bloc<LiveEvent, LiveState> {
  int currentDay = DateTime.now().weekday;

  LiveBloc() : super(LiveState()) {
    List<LectieModel> lectieDay = [];

    on<LiveShowOrar>((event, emit) {
      emit(LiveStateLoading());

      //DateTime currentTimeSeconds = DateFormat('HH:mm:ss').format(DateTime.now());
      DateTime currentTimeSeconds =
          DateFormat('HH:mm:ss').parse(DateFormat.Hms().format(DateTime.now()));
      DateTime currentTime =
          DateFormat('HH:mm').parse(DateFormat.Hm().format(DateTime.now()));
      //DateTime currentTime = DateFormat.Hm().parse("15:22:00");
      //print(currentTimeSeconds);

      switch (currentDay) {
        case 1:
          lectieDay = event.orarModel.luni;
          break;
        case 2:
          lectieDay = event.orarModel.marti;
          break;
        case 3:
          lectieDay = event.orarModel.miercuri;
          break;
        case 4:
          lectieDay = event.orarModel.joi;
          break;
        case 5:
          lectieDay = event.orarModel.vineri;
          break;
        case 6:
          lectieDay = event.orarModel.luni;
          break;
      }

      String? elapsedTime;
      String? remainingTime;
      List<LectieModel> lectieleTrecute = [];
      LectieModel? lectiaCurenta;
      List<LectieModel> lectiileUrmatoare = [];

      String difCalculator(DateTime time1,DateTime time2){

        Duration dif = time1.difference(time2);

        int min = 0;
        int secfrmmin = 0;
        int difsec = dif.inSeconds;
        while (true) {
          if (difsec - 60 > 0) {
            difsec = difsec - 60;
            min++;
          } else {
            secfrmmin = difsec;
            break;
          }
        }

        //SOME ERRORS HERE
        return '$min:$secfrmmin';
      }

      for (int i = 0; i < lectieDay.length; i++) {
        DateTime? previousEndingTime;

        if (i != 0) {
          String endTime = lectieDay[i - 1].endingTime;
          previousEndingTime = DateFormat("HH:mm").parse(endTime);
        }
        DateTime startDate =
            DateFormat("HH:mm").parse(lectieDay[i].startingTime);
        DateTime endingTime =
            DateFormat("HH:mm").parse(lectieDay[i].endingTime);

        if (endingTime.isBefore(currentTime)) {
          lectieleTrecute.add(lectieDay[i]); //STORING LESSON THAT HAVE FINISHED
        } else if (startDate.isBefore(currentTime) &&
            endingTime.isAfter(currentTime)) {

          elapsedTime = difCalculator(currentTimeSeconds,startDate);
          remainingTime = difCalculator(endingTime, currentTimeSeconds); 

          lectiaCurenta = lectieDay[i];
        } else if (previousEndingTime != null &&
            previousEndingTime.isBefore(currentTime) &&
            startDate.isAfter(currentTime)) {

          Duration freeTime = startDate.difference(previousEndingTime);

          lectiaCurenta = LectieModel(
            startingTime: '${freeTime.inMinutes} min',
            perecheNume: 'Recreatie',
            profesorNume: 'ss',
            perecheId: 1,
            endingTime: 'ss',
          );

          elapsedTime = difCalculator(currentTimeSeconds,previousEndingTime);
          remainingTime = difCalculator(startDate, currentTimeSeconds); 

        } else {
          if (previousEndingTime != null) {
            //IF FREE TIME IS ONE THERE WILL NOT BE DISPLAYED NEXT FREE TIMES (BUG)
            if(lectiaCurenta != null && lectiaCurenta.perecheNume != "Recreatie"){
              Duration freeTime = startDate.difference(previousEndingTime);
              lectiileUrmatoare.add(LectieModel(
                startingTime: '${freeTime.inMinutes} min',
                perecheNume: 'Recreatie',
                profesorNume: '',
                perecheId: 5,
                endingTime: '',
              ));
            }
          }
          lectiileUrmatoare.add(lectieDay[i]);
        }
      }

      emit(LiveStateShowCurrentOrar(
          beforeLessons: lectieleTrecute,
          afterLessons: lectiileUrmatoare,
          currentLessons: lectiaCurenta,
          remainingTime: remainingTime,
          elapsedTime: elapsedTime));
    });
  }
}
