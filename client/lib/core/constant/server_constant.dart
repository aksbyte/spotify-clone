class ServerConstant {
  //static const String serverURL = "http://192.168.50.173:8000";
  static const String serverURL = "http://192.168.148.173:8000";
  //static const String serverURL = "http://192.168.37.173:8000";
  //static const String serverURL = "http://192.168.85.173:8000";

  // Previous api 192.168.50.173
  static const String signupUrl = '${ServerConstant.serverURL}/auth/signup';
  static const String loginUrl = '${ServerConstant.serverURL}/auth/login';
  static const String auth = '${ServerConstant.serverURL}/auth/';
  static const String uploadSong = '${ServerConstant.serverURL}/song/upload';
  static const String getSongs = '${ServerConstant.serverURL}/song/list';
  static const String addFavorite = '${ServerConstant.serverURL}/song/favorite';
  static const String getFavoriteSongs = '${ServerConstant.serverURL}/song/list/favorites';


}
