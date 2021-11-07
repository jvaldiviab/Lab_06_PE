import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_visitors/models/user.dart';
import 'package:medical_visitors/services/user_service.dart';
import 'package:medical_visitors/widgets/app_textfield.dart';
import 'package:medical_visitors/widgets/dialogs.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController usernameController;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Text(
                        'Register Doctor',
                        style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                    Focus(
                      onFocusChange: (value) async {
                        if (!value) {
                          String result = await context
                              .read<UserService>()
                              .chechIfUserExists(
                                  usernameController.text.trim());
                          if (result == 'ok') {
                            context.read<UserService>().userExists = true;
                          } else {
                            context.read()<UserService>().userExists = false;
                            if (!result.contains(
                                'Este usuario ya existe, porfavor escoja otro nombre de usuario.')) {
                              showSnackBar(context, result);
                            }
                          }
                        }
                      },
                      child: AppTextField(
                        controller: usernameController,
                        labelText: 'Por favor ingrese su nombre de usuario',
                      ),
                    ),
                    Selector<UserService, bool>(
                      selector: (context, value) => value.userExists,
                      builder: (context, value, child) {
                        return value
                            ? Text(
                                ///check if value is true then username shown else a empty container
                                'nombre se usuario existente, por favor intente otror',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800),
                              )
                            : Container();
                      },
                    ),
                    AppTextField(
                      controller: nameController,
                      labelText: 'Por favor ingrese su nombre',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.purple),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (usernameController.text.isEmpty ||
                              nameController.text.isEmpty) {
                            showSnackBar(context,
                                'por favor ingrese todos los campos !');
                          } else {
                            User user = User(
                                name: nameController.text.trim(),
                                username: usernameController.text.trim());

                            String result = await context
                                .read<UserService>()
                                .createUser(user);

                            if (result != 'ok') {
                              showSnackBar(context, result);
                            } else {
                              showSnackBar(
                                  context, 'Nuevo usuario doctor se creo ');
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text('Registrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 30,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          Selector<UserService, bool>(
            selector: (context, value) => value.bussyCreate,
            builder: (context, value, child) {
              return value ? AppProgressIndicator() : Container();
            },
          ),
        ],
      ),
    );
  }
}

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(0.5),
      child: Center(
        child: Container(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            backgroundColor: Colors.purple,
          ),
        ),
      ),
    );
  }
}
