import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../exceptions/http_exception.dart';

class Auth with ChangeNotifier {
  static const _API_KEY = 'AIzaSyCO58bWMwxoRcjiC6jmU1pF2RuCQgMnqGA';
  static const _EMAIL = 'email';
  static const _PASSWORD = 'password';
  static const _RETURN_SECURE_TOKEN = 'returnSecureToken';
  static const _ID_TOKEN = 'idToken';
  static const _USER_ID = 'localId';

  String _token;
  DateTime _expiryDate;
  String _userId;

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
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> signUp(String email, String pwd) async =>
      _authenticate(email, pwd, 'signUp');

  Future<void> signIn(String email, String pwd) async =>
      _authenticate(email, pwd, 'signInWithPassword');

  void logout() {
    _userId = null;
    _token = null;
    _expiryDate = null;
    notifyListeners();
    print('log out called');
  }
}
