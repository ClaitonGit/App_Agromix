import 'package:agromix/RouteGenerator.dart';
import 'package:agromix/views/Anuncios.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xFFF57C00),
    primarySwatch: Colors.orange,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFF57C00)));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "AgroMIx",
    home: Anuncios(),
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
