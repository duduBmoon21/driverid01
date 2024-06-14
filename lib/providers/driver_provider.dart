import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/http_exception.dart';
import '../models/driver.dart';
import '../models/car.dart';
import 'auth.dart';

class DriverProvider with ChangeNotifier {
  late String? authToken;
  late String? driverId;

  late String _name;
  late String _email;
  late String _mobile;

  String get name => _name;
  String get email => _email;
  String get mobile => _mobile;

  List<Car> _cars = [];

  List<Car> get cars {
    return [..._cars];
  }

  void update(Auth auth) {
    authToken = auth.token;
    driverId = auth.driverId;
    bool status = false;
    // String? driverIdd;
    fetchDriverDetails();
  }

  Driver _driver = Driver();

  Driver get driver => _driver;

  bool _status = true;

  bool get status => _status;
//  Future<void> changeWorkMode(bool newStatus) async {
//     // Perform any asynchronous operations here, e.g., network request.
//     status = newStatus;
//     notifyListeners();
//   }

//   Future<void> tryStatus() async {
//     // Simulate a network request or other async operation
//     await Future.delayed(Duration(seconds: 2));
//     status = true; // or set based on actual logic
//     notifyListeners();
//   }
  Future<void> fetchDriverDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .get();
      if (!docSnapshot.exists) {
        return;
      }
      final data = docSnapshot.data()!;
      _name = data['name'];
      _email = data['email'];
      _mobile = data['mobile'];
      final carsData = data['cars'] as List<dynamic>?;
      final List<Car> loadedCars = [];
      if (carsData != null) {
        carsData.forEach((carData) {
          loadedCars.add(
            Car(
              id: carData['id'],
              carMake: carData['carMake'],
              carModel: carData['carModel'],
              carNumber: carData['carNumber'],
              carColor: carData['carColor'],
            ),
          );
        });
      }
      _cars = loadedCars;
      _driver = Driver(
        id: driverId,
        name: name,
        email: email,
        mobile: int.tryParse(mobile),
        cars: cars,
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addCar({
    required String carMake,
    required String carModel,
    required String carNumber,
    required String carColor,
  }) async {
    try {
      final newCarRef = FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .collection('cars')
          .doc();
      await newCarRef.set({
        'id': newCarRef.id,
        'carMake': carMake,
        'carModel': carModel,
        'carNumber': carNumber,
        'carColor': carColor,
      });
      final newCar = Car(
        id: newCarRef.id,
        carMake: carMake,
        carModel: carModel,
        carNumber: carNumber,
        carColor: carColor,
      );
      _cars.insert(0, newCar);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteCar(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(driverId)
          .collection('cars')
          .doc(id)
          .delete();
      _cars.removeWhere((car) => car.id == id);
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException('Could not delete car.');
    }
  }

  void changeWorkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _status = value;
    await prefs.setBool('$driverId-status', _status);
    notifyListeners();
  }

  Future<void> tryStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('$driverId-status')) {
      _status = true;
    }
    final extractedValue = prefs.getBool('$driverId-status')!;
    _status = extractedValue;
    notifyListeners();
  }
}
