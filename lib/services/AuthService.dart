import 'package:workshop_6_json/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{
  static final String IS_LOGIN = "is_login";
  static final String USERNAME = "username";

  Future<bool> login({required User user}) async{
    if(user.Username =="admin@gmail.com" && user.Password =="password"){
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString(USERNAME, user.Username);  //เก็บ user ไว้ที่เครื่อง
      _prefs.setBool(IS_LOGIN, true);  //เก็บค่าว่าเคย login
      return true;
    }
    return false;
  }

  // Future<bool> isLogin() async{
  //    SharedPreferences _prefs = await SharedPreferences.getInstance();
  //    return _prefs.getBool(IS_LOGIN) ?? false;
  // }

    Future<bool> isLogin() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    return _prefs.getBool(IS_LOGIN) ?? false;
  }

  Future logout() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove(IS_LOGIN);   // clear ข้อมูล logout

    return await Future<void>.delayed(Duration(seconds: 1));  // clear key logout delay 1 นาที
  }
}