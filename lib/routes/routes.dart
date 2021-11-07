import 'package:flutter/material.dart';
import 'package:medical_visitors/pages/login.dart';
import 'package:medical_visitors/pages/register.dart';
import 'package:medical_visitors/pages/patient_page.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String patientPage = '/patientPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );

      case registerPage:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );

      case patientPage:
        return MaterialPageRoute(
          builder: (context) => PatientPage(),
        );

      default:
        throw FormatException(
            'Ruta no encontrada! revise sus rutas nuevamente');
    }
  }
}
