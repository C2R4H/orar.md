import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../backend/database/firestore_database.dart';
import '../../../../backend/database/cache.dart';
import '../../models/colegiu_model.dart';
import '../../models/orar_model.dart';

part 'select_state.dart';
part 'select_event.dart';

class SelectBloc extends Bloc<SelectEvent, SelectState>{
  SelectBloc() : super(SelectState()){

    FirestoreMethods _firestoreMethods = FirestoreMethods();
    ColegiuModel? colegiuModel;
    String? institution;

    on<LoadColegii>((event, emit) async {
      emit(SelectStateLoading());
      institution = event.institution;
      await _firestoreMethods.getColegii(event.institution).then((data){
        emit(SelectStateColegiiLoaded(data));
      });
    });

    on<LoadGroups>((event, emit) {
      colegiuModel = event.colegiuModel;
      emit(SelectStateChoosedColegiu(event.colegiuModel));
    });

    on<LoadOrar>((event, emit) async {
      emit(SelectStateLoading());
      await _firestoreMethods.getGrupaOrar(event.grupaName,event.colegiuId,institution!).then((data) async {

        await CacheMethods.cacheColegiuName(colegiuModel!.colegiuName);
        await CacheMethods.cacheColegiuID(colegiuModel!.colegiuID);
        await CacheMethods.cacheGrupaName(event.grupaName);
        await CacheMethods.cacheInstitutionType(institution!);

        emit(SelectStateChoosedGroup(data,colegiuModel!,event.grupaName));
      });
    });

  }
}
