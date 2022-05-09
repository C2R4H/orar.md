import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../backend/database/firestore_database.dart';
import '../../user_model.dart';

import '../../models/orar_model.dart';
import '../../models/perechiSunetTime_model.dart';

part 'orar_state.dart';
part 'orar_event.dart';

class OrarBloc extends Bloc<OrarEvent, OrarState>{

  final FirestoreMethods _firestoreDatabase = FirestoreMethods();

  OrarBloc() : super(OrarState()){
    on<GetOrarData>((event, emit) async {
      emit(OrarStateLoading());
      List<PerechiSunetTime> perechiSunet = await _firestoreDatabase.getOrarSunete(event.userModel.colegiuID,event.userModel.institutie);
      await _firestoreDatabase.getGrupaOrar(event.userModel.grupaName,event.userModel.colegiuID,event.userModel.institutie).then((data){
        if(data.luni.length!=0) {
          emit(OrarStateLoadedData(data,perechiSunet));
        }
        else{
          emit(OrarStateError('There was an error getting the data'));
        }
      });
    });
  }
}

