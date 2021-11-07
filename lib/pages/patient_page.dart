import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:medical_visitors/models/patient.dart';
import 'package:medical_visitors/models/user.dart';
import 'package:medical_visitors/services/patient_service.dart';
import 'package:medical_visitors/services/user_service.dart';
import 'package:medical_visitors/widgets/dialogs.dart';
import 'package:location/location.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  _PatientPageState createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  late TextEditingController patientController;
  late TextEditingController patientNameController;
  late TextEditingController patientSurnameController;
  late TextEditingController patientHeightsController;
  late TextEditingController patientDateBirthController;
  late TextEditingController patientAddressController;

  String _locLatitud = "";
  String _locLongitud = "";

  Future<void> _getCurrentLocation() async {
    try {
      final locData = await Location().getLocation();
      _locLatitud = locData.latitude.toString();
      _locLongitud = locData.longitude.toString();
    } catch (error) {
      // print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    patientController = TextEditingController();
    patientNameController = TextEditingController();
    patientSurnameController = TextEditingController();
    patientHeightsController = TextEditingController();
    patientDateBirthController = TextEditingController();
    patientAddressController = TextEditingController();
  }

  @override
  void dispose() {
    patientController.dispose();
    patientNameController.dispose();
    patientSurnameController.dispose();
    patientHeightsController.dispose();
    patientDateBirthController.dispose();
    patientAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.blue.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text('Agregar nuevo paciente'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: 'Por favor ingrese DNI'),
                                      controller: patientController,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: 'Por favor ingrese nombre'),
                                      controller: patientNameController,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText:
                                              'Por favor ingrese apellidos'),
                                      controller: patientSurnameController,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText:
                                              'Por favor ingrese su altura en cm'),
                                      controller: patientHeightsController,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                          hintText: 'Fecha de nacimiento'),
                                      controller: patientDateBirthController,
                                    ),
                                    TextField(
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: InputDecoration(
                                          hintText: 'Ingrese dirección'),
                                      controller: patientAddressController,
                                    ),
                                    TextButton.icon(
                                      icon: const Icon(
                                        Icons.location_on,
                                        color: Colors.redAccent,
                                        // size: 24.0,
                                      ),
                                      style: TextButton.styleFrom(
                                          elevation: 0,
                                          textStyle: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      label: const Text(
                                          'Presionar para guardar ubicacion actual'),
                                      onPressed: _getCurrentLocation,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('Guardar'),
                                  onPressed: () async {
                                    if (patientController.text.isEmpty &&
                                        patientNameController.text.isEmpty &&
                                        patientSurnameController.text.isEmpty &&
                                        patientHeightsController.text.isEmpty &&
                                        patientDateBirthController
                                            .text.isEmpty) {
                                      showSnackBar(context,
                                          'por favor ingrese datos primero , entonces guarde');
                                    } else {
                                      String username = context
                                          .read<UserService>()
                                          .currentUser
                                          .username;
                                      Patient patient = Patient(
                                          created: DateTime.now(),
                                          username: username.trim(),
                                          title: patientController.text.trim(),
                                          address: patientAddressController.text
                                              .trim(),
                                          dateBirth: DateTime.utc(
                                              int.parse(patientDateBirthController.text
                                                  .trim()
                                                  .substring(6, 10)),
                                              int.parse(
                                                  patientDateBirthController.text
                                                      .trim()
                                                      .substring(3, 5)),
                                              int.parse(
                                                  patientDateBirthController.text
                                                      .trim()
                                                      .substring(0, 2)),
                                              0,
                                              0,
                                              0),
                                          heights: int.parse(
                                              patientHeightsController.text.trim()),
                                          name: patientNameController.text.trim().substring(0, 1).toUpperCase() + patientNameController.text.trim().substring(1),
                                          surname: patientSurnameController.text.trim().substring(0, 1).toUpperCase() + patientSurnameController.text.trim().substring(1),
                                          lat: _locLatitud,
                                          lon: _locLongitud);
                                      if (context
                                          .read<PatientService>()
                                          .patients
                                          .contains(patient)) {
                                        showSnackBar(context,
                                            'Duplicate value . Please try again ');
                                      } else {
                                        String result = await context
                                            .read<PatientService>()
                                            .createPatient(patient);
                                        if (result == 'ok') {
                                          showSnackBar(context,
                                              'Nuevo paciente agregado');
                                          patientController.text = '';
                                          patientNameController.text = '';
                                          patientSurnameController.text = '';
                                          patientHeightsController.text = '';
                                          patientDateBirthController.text = '';
                                          patientAddressController.text = '';
                                        } else {
                                          showSnackBar(context, result);
                                        }
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Selector<UserService, User>(
                  selector: (context, value) => value.currentUser,
                  builder: (context, value, child) {
                    return Text(
                      'Pacientes de: ${value.name.toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w200,
                        color: Colors.blue.shade800,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                  child: Consumer<PatientService>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        itemCount: value.patients.length,
                        itemBuilder: (context, index) {
                          return PatientCard(
                            patient: value.patients[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  const PatientCard({
    Key? key,
    required this.patient,
  }) : super(key: key);

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade300,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Eliminar',
            color: Colors.purple[600],
            icon: Icons.delete,
            onTap: () async {
              String result =
                  await context.read<PatientService>().deletePatient(patient);
              if (result == 'ok') {
                showSnackBar(context, 'succesfully deleted ');
              } else {
                showSnackBar(context, result);
              }
            },
          ),
        ],
        child: ListTile(
          subtitle: Text(
            'Nombre: ${patient.name}\nApellidos: ${patient.surname}\nF.Nacimiento: ${patient.dateBirth}\nAltura: ${patient.heights}\nDirección: ${patient.address}\nLatitud: ${patient.lat}\nLongitud: ${patient.lon}',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          title: Text(
            "DNI: " + patient.title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              decoration:
                  patient.done ? TextDecoration.overline : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
