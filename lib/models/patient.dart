import 'package:flutter/cupertino.dart';

final String patientTable = 'patient';

class PatientFields {
  static final String username = 'username';
  static final String title = 'title';
  static final String done = 'done';
  static final String created = 'created';
  static final String name = 'name';
  static final String surname = 'surname';
  static final String dateBirth = 'date_birth';
  static final String heights = 'heights';
  static final String address = 'address';
  static final String lat = 'lat';
  static final String lon = 'lon';
  static final List<String> allFields = [
    username,
    title,
    done,
    created,
    name,
    surname,
    dateBirth,
    heights,
    address,
    lat,
    lon,
  ];
}

class Patient {
  final String username;
  final String title;
  bool done;
  final DateTime created;
  final String name;
  final String surname;
  final DateTime dateBirth;
  final int heights;
  final String address;
  final String lat;
  final String lon;

  Patient({
    required this.username,
    required this.title,
    this.done = false,
    required this.created,
    required this.name,
    required this.surname,
    required this.dateBirth,
    required this.heights,
    required this.address,
    required this.lat,
    required this.lon,
  });

  Map<String, Object?> toJson() => {
        PatientFields.username: username,
        PatientFields.title: title,
        PatientFields.done: done ? 1 : 0,
        PatientFields.created: created.toIso8601String(),
        PatientFields.name: name,
        PatientFields.surname: surname,
        PatientFields.dateBirth: dateBirth.toIso8601String(),
        PatientFields.heights: heights,
        PatientFields.address: address,
        PatientFields.lat: lat,
        PatientFields.lon: lon,
      };

  static Patient fromjson(Map<String, Object?> json) => Patient(
        username: json[PatientFields.username] as String,
        title: json[PatientFields.title] as String,
        created: DateTime.parse(json[PatientFields.created] as String),
        done: json[PatientFields.done] == 1 ? true : false,
        name: json[PatientFields.name] as String,
        surname: json[PatientFields.surname] as String,
        dateBirth: DateTime.parse(json[PatientFields.dateBirth] as String),
        heights: int.parse(json[PatientFields.heights] as String),
        address: json[PatientFields.address] as String,
        lat: json[PatientFields.lat] as String,
        lon: json[PatientFields.lon] as String,
      );

  @override
  bool operator ==(covariant Patient patient) {
    return (this.username == patient.username) &&
        (this.title.toUpperCase().compareTo(patient.title.toUpperCase()) == 0);
  }

  @override
  int get hashCode {
    return hashValues(
      username,
      title,
      name,
      surname,
      heights,
      address,
      lat,
      lon,
    );
  }
}
