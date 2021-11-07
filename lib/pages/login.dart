import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_visitors/routes/routes.dart';
import 'package:medical_visitors/services/user_service.dart';
import 'package:medical_visitors/widgets/app_textfield.dart';
import 'package:medical_visitors/widgets/dialogs.dart';
import 'package:medical_visitors/services/patient_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
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
              ]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/log_container_mv.png",
                  width: 300,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'Bienvenido',
                    style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
                AppTextField(
                  controller: usernameController,
                  labelText: 'Por favor ingrese su nombre de usuario',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (usernameController.text.isEmpty) {
                        showSnackBar(context,
                            'por favor ingrese su nombre de usuario primero !');
                      } else {
                        String result = await context
                            .read<UserService>()
                            .getUser(usernameController.text.trim());
                        if (result != 'ok') {
                          showSnackBar(context, result);
                        } else {
                          String username =
                              context.read<UserService>().currentUser.username;
                          context.read<PatientService>().getPatients(username);
                          Navigator.of(context)
                              .pushNamed(RouteManager.patientPage);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple,
                    ),
                    child: Text('Continuar'),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteManager.registerPage);
                  },
                  child: Text('Registrar nuevo doctor'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
