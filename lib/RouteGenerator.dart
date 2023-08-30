import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agromix/views/Anuncios.dart';
import 'package:agromix/views/Login.dart';
import 'package:agromix/views/MeusAnuncios.dart';
import 'package:agromix/views/NovoAnuncio.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Anuncios());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/meus-anuncios":
        return MaterialPageRoute(builder: (_) => const MeusAnuncios());
      case "/novo-anuncio":
        return MaterialPageRoute(builder: (_) => NovoAnuncio());
      default:
        _erroRota();
    }
    return null;
  }

  static Route<dynamic>? _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
