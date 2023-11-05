import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ui_one/features/auth/presentation/pages/retrain.dart';

class ModelPage extends StatefulWidget {
  static const String id = "Model_Page";
  const ModelPage({super.key});

  @override
  State<ModelPage> createState() => _ModelPageState();
}

class _ModelPageState extends State<ModelPage> {
  final _formKey = GlobalKey<FormState>();
  String _respuesta = '';
  double? mean_radius, mean_texture, mean_perimeter, mean_area, mean_smoothness;

  Future<void> _consultarModelo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse(
          'https://breast-cancer-service-itzelll.cloud.okteto.net/diagnosis');
      final response = await http.post(url,
          body: json.encode({
            "mean_radius": mean_radius,
            "mean_texture": mean_texture,
            "mean_perimeter": mean_perimeter,
            "mean_area": mean_area,
            "mean_smoothness": mean_smoothness,
          }),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse);
        double? diagnosis = jsonResponse['diagnosis'];
        setState(() {
          _respuesta = 'Diagnosis: ${diagnosis?.toStringAsFixed(3)}';
        });
      } else {
        setState(() {
          _respuesta =
              'Error al obtener respuesta, revisa que todos los campos sean válidos';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 65, 112, 194),
      appBar: AppBar(
        title: Text(
          "Modelo Probabilidad para Cáncer de Mama",
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
                    decoration: InputDecoration(
                      labelText: 'Radio medio',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        mean_radius = double.tryParse(value ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Textura media',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        mean_texture = double.tryParse(value ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Perímetro medio',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        mean_perimeter = double.tryParse(value ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Area media',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        mean_area = double.tryParse(value ?? ''),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Suavidad media',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        mean_smoothness = double.tryParse(value ?? ''),
                  ),
                ),

                // Agrega más campos de entrada de datos aquí según tu necesidad
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _consultarModelo,
                  child: Text(
                    'Hacer consulta',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 14, 12, 10),
                    padding: EdgeInsets.symmetric(horizontal: 65, vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 65, 112, 194),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    _respuesta,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla "retrain.dart"
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Reentreno()));
                  },
                  child: Text(
                    'Reentrenar modelo',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 45, 16, 133),
                    padding: EdgeInsets.symmetric(horizontal: 65, vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
