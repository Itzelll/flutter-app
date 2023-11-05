import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Importa flutter_dotenv

class Reentreno extends StatefulWidget {
  static const String id = "Reentreno";
  const Reentreno({super.key});

  @override
  State<Reentreno> createState() => _ReentrenoState();
}

class _ReentrenoState extends State<Reentreno> {
  final _formKey = GlobalKey<FormState>();
  String _respuesta = '';
  TextEditingController _urlController = TextEditingController();
  TextEditingController _shaController = TextEditingController();

  Future<void> _consultarModelo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  Future<void> _llamadoapi() async {
    await dotenv.load(); // Carga las variables de entorno desde .env
    final authorizationToken = dotenv.env['AUTH_TOKEN'];

    if (authorizationToken == null || authorizationToken.isEmpty) {
      setState(() {
        _respuesta = 'Error: Token de autorización no encontrado';
      });
      return;
    }

    print(_urlController.text);

    final url = Uri.parse(
        'https://api.github.com/repos/Itzelll/breast-cancer/dispatches');

    final body = json.encode({
      "event_type": "ml_ci_cd",
      "client_payload": {
        "dataseturl": _urlController.text,
        "sha": _shaController.text,
      }
    });

    final headers = {
      'Authorization': 'bearer $authorizationToken',
      'Accept': 'application/vnd.github.v3+json',
      'Content-Type': 'application/json',
    };

    final response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 204) {
      setState(() {
        _respuesta = 'Llamado a API exitoso';
      });
    } else {
      setState(() {
        _respuesta = 'Error al hacer el llamado a la API';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 44, 85, 155),
      appBar: AppBar(
        title: Text(
          "Reentrenar Modelo de Cáncer de Mama",
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller:
                        _shaController, // Asociar el controlador al campo
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(
                        color: Colors.grey, // Color del texto del label (gris)
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .white), // Color del borde cuando no está enfocado
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Color del borde cuando está enfocado
                      ),
                      hintStyle: TextStyle(
                          color: Colors
                              .grey), // Color del texto de sugerencia (gris)
                    ),
                    style: TextStyle(
                      color: Colors.black, // Color del texto de entrada (negro)
                    ),
                    onSaved: (value) {},
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller:
                        _urlController, // Asociar el controlador al campo
                    decoration: InputDecoration(
                      labelText: 'URL',
                      labelStyle: TextStyle(
                        color: Colors.grey, // Color del texto del label (gris)
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .white), // Color del borde cuando no está enfocado
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Color del borde cuando está enfocado
                      ),
                      hintStyle: TextStyle(
                          color: Colors
                              .grey), // Color del texto de sugerencia (gris)
                    ),
                    style: TextStyle(
                      color: Colors.black, // Color del texto de entrada (negro)
                    ),
                    onSaved: (value) {},
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _llamadoapi,
                  child: const Text(
                    'Entrenar Modelo',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 0, 0, 0),
                    padding: EdgeInsets.symmetric(horizontal: 65, vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  _respuesta,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
