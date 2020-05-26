import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/http_exception.dart';

class Auth with ChangeNotifier {
  static const _API_KEY = 'AIzaSyCO58bWMwxoRcjiC6jmU1pF2RuCQgMnqGA';
  static const _EMAIL = 'email';
  static const _PASSWORD = 'password';
  static const _RETURN_SECURE_TOKEN = 'returnSecureToken';
  static const _ID_TOKEN = 'idToken';
  static const _USER_ID = 'localId';

  static const USER_DATA_PREF = 'userData';
  static const USER_ID_PREF = 'userId';
  static const USER_TOKEN_PREF = 'token';
  static const USER_EXP_DATE_PREF = 'expiryDate';

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth => token != null;

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get uid => _userId;

  Future _authenticate(String email, String pwd, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$_API_KEY';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          _EMAIL: email,
          _PASSWORD: pwd,
          _RETURN_SECURE_TOKEN: true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HTTPException(responseData['error']['message']);
      }
      _token = responseData[_ID_TOKEN];
      _userId = responseData[_USER_ID];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          USER_TOKEN_PREF: _token,
          USER_ID_PREF: _userId,
          USER_EXP_DATE_PREF: _expiryDate.toIso8601String(),
        },
      );
//      print('login: $userData');
      prefs.setString(USER_DATA_PREF, userData);
    } catch (err) {
      throw err;
    }
  }

  Future<void> signUp(String email, String pwd) async =>
      _authenticate(email, pwd, 'signUp');

  Future<void> signIn(String email, String pwd) async =>
      _authenticate(email, pwd, 'signInWithPassword');

  Future logout() async {
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
//    prefs.remove(USER_DATA_PREF);
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(USER_DATA_PREF)) return false;
//    print(prefs.getString(USER_DATA_PREF));
    final extractedUserData =
        json.decode(prefs.getString(USER_DATA_PREF)) as Map;
    final expdate = DateTime.parse(extractedUserData[USER_EXP_DATE_PREF]);
    if (expdate.isBefore(DateTime.now())) return false;
    _token = extractedUserData[USER_TOKEN_PREF];
//    print(_token);
    _userId = extractedUserData[USER_ID_PREF];
//    print(_userId);
    _expiryDate = expdate;
//    print(_expiryDate);
    notifyListeners();
    _autoLogout();
    return true;
  }

  void _autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    final secExp = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: secExp), () => logout());
  }
}
