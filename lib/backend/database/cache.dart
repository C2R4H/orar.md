import 'package:shared_preferences/shared_preferences.dart';

class CacheMethods {
  static String cacheUserColegiuName= "COLEGIUNAME";
  static String cacheUserColegiuID= "COLEGIUID";
  static String cacheUserGrupaName = "GRUPANAME";
  static String cacheUserInstitutionType = "INSTITUTIONTYPE";

  //Caching the college name
  static Future<bool> cacheColegiuName(String colegiuName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(cacheUserColegiuName , colegiuName);
  }

  //Caching the college id 
  static Future<bool> cacheColegiuID(String colegiuID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(cacheUserColegiuID, colegiuID);
  }

  //Caching the group name
  static Future<bool> cacheGrupaName(String grupaName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(cacheUserGrupaName, grupaName);
  }

  //Caching the institution type  
  static Future<bool> cacheInstitutionType(String institution) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(cacheUserInstitutionType, institution);
  }

  //
  //Retrieving data from the cache
  //

  //Retrieving the colegiu cache name 
  static Future<String?> getCachedColegiuName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(cacheUserColegiuName);
  }

  //Retrieving the colegiu cache name 
  static Future<String?> getCachedColegiuID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(cacheUserColegiuID);
  }

  //Retrieving the colegiu cache name 
  static Future<String?> getCachedGroupName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(cacheUserGrupaName);
  }

  //Retrieving the institution cache type  
  static Future<String?> getCachedInstitutionType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(cacheUserInstitutionType);
  }
}
