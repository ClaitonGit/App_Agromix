import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes {

  static List<DropdownMenuItem<String>> getEstados(){

    List<DropdownMenuItem<String>> listaItensDropEstados = [];

    //Estados

    listaItensDropEstados.add(DropdownMenuItem(
      child: Text("Região", style: TextStyle( color: Colors.orange),),
      value:null,
    ));

    for (var estado in Estados.listaEstadosSigla) {
      listaItensDropEstados.add(DropdownMenuItem(
        child: Text(estado),
        value: estado,
      ));
    }
    return listaItensDropEstados;

  }


 static List<DropdownMenuItem<String>> getCategorias(){

    List<DropdownMenuItem<String>> itensDropCategorias = [];

    itensDropCategorias.add(DropdownMenuItem(
      child: Text("Categoria", style: TextStyle( color: Colors.orange),), value:null,));

      itensDropCategorias.add(DropdownMenuItem(
        child: Text("Bovino"),
        value: "boi",
      ));

      itensDropCategorias.add(DropdownMenuItem(
        child: Text("Suinos"),
        value: "porco",
      ));

      itensDropCategorias.add(DropdownMenuItem(
        child: Text("Ovino"),
        value: "ovelha",
      ));

      itensDropCategorias.add(DropdownMenuItem(
        child: Text("caprino"),
        value: "cabra",
      ));

      itensDropCategorias.add(DropdownMenuItem(
        child: Text("Equino"),
        value: "cavalo",
      ));

      itensDropCategorias.add(DropdownMenuItem(
        child: Text("Muar"),
        value: "mula",
      ));

      itensDropCategorias.add(DropdownMenuItem(
        child: Text("Bufalino"),
        value: "bufalo",
      ));

      itensDropCategorias.add(DropdownMenuItem(
        child: Text("Asinino"),
        value: "jumento",
      ));

      return itensDropCategorias;

  }

}