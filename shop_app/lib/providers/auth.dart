import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static const _API_KEY = 'AIzaSyCO58bWMwxoRcjiC6jmU1pF2RuCQgMnqGA';
  static const _EMAIL = 'email';
  static const _PASSWORD = 'password';
  static const _RETURN_SECURE_TOKEN = 'returnSecureToken';

  String _token;
  DateTime _expiryDate;
  String _userId;

  Future _authenticate(email, pwd) async {}

  Future<void> signUp(String email, String pwd) async {
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
    } catch (err) {
      throw err;
    }
  }

  Future<void> signUp(String email, String pwd) async {
    return _authenticate(email, pwd, 'signUp');
  }

  Future<void> signIn(String email, String pwd) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_API_KEY';
    final response = await http.post(
      url,
      body: json.encode({
        _EMAIL: email,
        _PASSWORD: pwd,
        _RETURN_SECURE_TOKEN: true,
      }),
    );
  }
}
