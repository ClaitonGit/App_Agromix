import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agromix/models/Anuncio.dart';
import 'package:agromix/util/Configuracoes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'views.widgets/itemAnuncio.dart';


class Anuncios extends StatefulWidget {
  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  List<String> itensMenu = [];
  late List<DropdownMenuItem<String>> _listaItensDropEstados;
  late List<DropdownMenuItem<String>> _listaItensDropCategorias;

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String? _itemSelecionadoEstado;
  String? __itemSelecionadoCategoria;


  _escolhaMenuItem(String ItemEscolhido) {
    switch (ItemEscolhido) {
      case "Meus-Anuncios":
        Navigator.pushNamed(context, "/meus-anuncios");
        break;

      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, "/login");
        break;

      case "Sair":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamed(context, "/login");
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      itensMenu = ["Entrar / Cadastrar"];
    } else {
      itensMenu = ["Meus-Anuncios", "Sair"];
    }
  }

  _CarregarItensDropdow() {
    //Categorias
    _listaItensDropCategorias = Configuracoes.getCategorias();
    //Estados
    _listaItensDropEstados = Configuracoes.getEstados();
  }

  // carrega dados do banco de dados firebase
  Future<Stream<QuerySnapshot>?> _adicionarListenerAnuncios() async {

     FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("anuncios")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    _CarregarItensDropdow();
    _verificarUsuarioLogado();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("AgroMix"),
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (contex) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonHideUnderline(
                      child: Center(
                    child: DropdownButton(
                      iconEnabledColor: Colors.orange,
                      value: _itemSelecionadoEstado,
                      items: _listaItensDropEstados,
                      style: TextStyle(fontSize: 22, color: Colors.black),
                      onChanged: (estado) {
                        setState(() {
                          _itemSelecionadoEstado = estado as String?;
                        });
                      },
                    ),
                  )),
                ),
                Container(
                  color: Colors.grey[200],
                  width: 2,
                  height: 60,
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                      child: Center(
                    child: DropdownButton(
                      iconEnabledColor: Colors.orange,
                      value: __itemSelecionadoCategoria,
                      items: _listaItensDropCategorias,
                      style: TextStyle(fontSize: 22, color: Colors.black),
                      onChanged: (categoria) {
                        setState(() {
                          __itemSelecionadoCategoria = categoria as String?;
                        });
                      },
                    ),
                  )),
                ),
              ],
            ),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  case ConnectionState.done:


                  QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

                    if (querySnapshot.docs.length == 0) {
                      return Container(
                        padding: EdgeInsets.all(25),
                        child: Text("Nenhum anuncio! :(",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return Expanded(
                        child: ListView.builder(
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (_, indice) {
                              List<DocumentSnapshot>? anuncios = querySnapshot.docs.toList();
                              DocumentSnapshot documentSnapshot = anuncios[indice];
                              Anuncio  anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                              return itemAnuncio(
                                anuncio: anuncio,
                                onTapItem: () {

                                },
                              );
                            }
                            ),
                    );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
