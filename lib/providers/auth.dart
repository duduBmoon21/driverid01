import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/http_exception.dart';


class Auth with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _token;
  DateTime? _expiryDate;
  String? _driverId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get driverId {
    if (isAuth) {
      return _driverId;
    }
    return null;
  }

  Future<void> signupWithEmail({
    required String email,
    required String password,
    required String name,
    required String mobile,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        IdTokenResult tokenRes = await user.getIdTokenResult();
        _driverId = user.uid;
        _token = tokenRes.token;
        _expiryDate = tokenRes.expirationTime;
        _autoLogout();
        notifyListeners();
        
        await _firestore.collection('drivers').doc(_driverId).set(
          {
            'name': name,
            'email': email,
            'mobile': mobile,
          },
        );

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'userId': _driverId,
            'expiryDate': _expiryDate!.toIso8601String(),
          },
        );
        await prefs.setString('userData', userData);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        final doc = await _firestore.collection('drivers').doc(user.uid).get();
        if (!doc.exists) {
          throw HttpException('User does not exist');
        }
        IdTokenResult tokenRes = await user.getIdTokenResult();
        _driverId = user.uid;
        _token = tokenRes.token;
        _expiryDate = tokenRes.expirationTime;
        _autoLogout();
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'userId': _driverId,
            'expiryDate': _expiryDate!.toIso8601String(),
          },
        );
        await prefs.setString('userData', userData);
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData = json.decode(prefs.getString('userData')!);
    final expiryDate = DateTime.parse(extractedData['expiryDate'] as String);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'] as String;
    _driverId = extractedData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _token = null;
    _driverId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.remove('$driverId-status');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final expiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: expiry),
      logout,
    );
  }
}
