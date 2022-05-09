import 'package:cloud_firestore/cloud_firestore.dart';

import '../../midend/models/colegiu_model.dart';
import '../../midend/models/lectie_model.dart';
import '../../midend/models/orar_model.dart';
import '../../midend/models/perechiSunetTime_model.dart';

class FirestoreMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //THIS CAN BE DONE IN GETCOLEGII
  Future<List<PerechiSunetTime>> getOrarSunete(String colegiuID,String institution) async {
    List<PerechiSunetTime> perechiSunet = [];
    await firestore.collection(institution).doc(colegiuID).get().then((doc) {
      int i = 1;
      while (doc.data()!['$i'] != null) {
        String time = doc.data()!['$i'];
        String perecheStarting = time.substring(0, 5);
        String perecheEnding = time.substring(6, 11);
        perechiSunet.add(PerechiSunetTime(
            startingTime: perecheStarting, endingTime: perecheEnding));
        i++;
      }
    });

    return perechiSunet;
  }

  Future<List<ColegiuModel>> getColegii(String institution) async {
    List<ColegiuModel> colegiuModel = [];
    await firestore.collection(institution).get().then((data) {
      data.docs.forEach((doc) {

        int i = 1;
        List<String> colegiuGrupe = [];
        while (true) {
          if (doc.data()['grupa$i'] == null) break;
          colegiuGrupe.add(doc.data()['grupa$i']);
          i++;
        }

        colegiuModel.add(ColegiuModel(
            colegiuName: doc.data()['name'],
            listaGrupeName: colegiuGrupe,
            colegiuID: doc.id));
      });
    });
    return colegiuModel;
  }

  Future<OrarModel> getGrupaOrar(String grupa, String colegiuID,String institution) async {
    List<PerechiSunetTime> perechiSunete = await getOrarSunete(colegiuID,institution);

    List<LectieModel> luniOrar = [];
    List<LectieModel> martiOrar = [];
    List<LectieModel> miercuriOrar = [];
    List<LectieModel> joiOrar = [];
    List<LectieModel> vineriOrar = [];

    await firestore
        .collection(institution)
        .doc(colegiuID)
        .collection(grupa)
        .get()
        .then((data) {
      data.docs.forEach((d) {

        List<LectieModel> orarDay(){
          List<LectieModel> orarDay = [];

          for (int i = 1; i <= 8; i++)
            if (d.data()['$i-pereche'] != null){

              String pereche_name = d.data()['$i-pereche'].toString();
              String profesor_name = d.data()['$i-profesor'].toString();
              String cabinet = d.data()['$i-cabinet'].toString();

              orarDay.add(LectieModel(
                  perecheNume: pereche_name,
                  profesorNume: profesor_name,
                  startingTime: perechiSunete[i-1].startingTime,
                  endingTime: perechiSunete[i-1].endingTime,
                  perecheId: i));
            }

          return orarDay;
        }

        if (d.data()['name'] == 'Luni')
          luniOrar = orarDay();
        if (d.data()['name'] == 'Marti')
          martiOrar = orarDay();
        if (d.data()['name'] == 'Miercuri')
          miercuriOrar = orarDay();
        if (d.data()['name'] == 'Joi')
          joiOrar = orarDay();
        if (d.data()['name'] == 'Vineri')
          vineriOrar = orarDay();

      });
    });
    OrarModel orarModel =
        OrarModel(luniOrar, martiOrar, miercuriOrar, joiOrar, vineriOrar);
    return orarModel;
  }
}
