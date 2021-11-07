import 'package:flutter/material.dart';
import 'package:medical_visitors/database/patient_database.dart';
import 'package:medical_visitors/models/patient.dart';

class PatientService with ChangeNotifier {
  List<Patient> _patients = [];

  List<Patient> get patients => _patients;

  Future<String> getPatients(String username) async {
    try {
      _patients = await PatientDatabase.instance.getPatient(username);
      notifyListeners();
    } catch (e) {
      debugPrint("-----------------" + username + username);
      return "aqui es " + e.toString();
    }
    return 'ok';
  }

  Future<String> deletePatient(Patient patient) async {
    try {
      await PatientDatabase.instance.deletePatient(patient);
    } catch (e) {
      return e.toString();
    }
    String result = await getPatients(patient.username);
    return result;
  }

  Future<String> createPatient(Patient patient) async {
    try {
      await PatientDatabase.instance.createPatient(patient);
      debugPrint("si se agrego XD XD");
    } catch (e) {
      return "ERERERERERER" + e.toString();
    }
    String result = await getPatients(patient.username);
    debugPrint(result);
    debugPrint(patient.toString());
    debugPrint(patient.created.toString());
    debugPrint(patient.username);
    debugPrint(patient.title);
    debugPrint(patient.dateBirth.toString());
    debugPrint(patient.heights.toString());
    debugPrint(patient.name);
    debugPrint(patient.surname);
    debugPrint(patient.lat);
    debugPrint(patient.lon);
    return result;
  }

  Future<String> togglePatientDone(Patient patient) async {
    try {
      await PatientDatabase.instance.togglePatientDone(patient);
    } catch (e) {
      return e.toString();
    }
    String result = await getPatients(patient.username);
    return result;
  }
}
