import 'package:firebase_auth/firebase_auth.dart';
import '../backend/database/auth_database.dart';
import '../backend/database/cache.dart';
import 'models/orar_model.dart';

class UserModel{
  AuthMethods _authMethods = AuthMethods();

  //WE WILL CACHE THIS DATA FOR EASY ACCESS 

  bool isAuthenticated = false;
  OrarModel? orar;

  String institutie = 'none';
  String colegiuID = 'none';
  String colegiuName = 'none';
  String grupaName = 'none';

  String lessonType = 'none';
  String lessonTypePlural = 'none';

  getData() async {
    User? user = _authMethods.auth.currentUser;
    if(user!=null){
      isAuthenticated = true;
      String? colegiuNameNull = await CacheMethods.getCachedColegiuName();
      String? colegiuIDNull = await CacheMethods.getCachedColegiuID();
      String? grupaNameNull  = await CacheMethods.getCachedGroupName();
      String? institutieNull = await CacheMethods.getCachedInstitutionType();

      if(colegiuNameNull!=null)
        colegiuName = colegiuNameNull;
      if(colegiuIDNull!=null)
        colegiuID = colegiuIDNull;
      if(grupaNameNull!=null)
        grupaName = grupaNameNull;
      if(institutieNull!=null)
        institutie = institutieNull;
    }
  }

  UserModel(){
    getData();
  }

}
