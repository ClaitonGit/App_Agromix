import 'dart:async';
import 'package:agromix/models/Anuncio.dart';
import 'package:agromix/views/views.widgets/itemAnuncio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({Key? key}) : super(key: key);

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
   String? idUsuarioLogado;

  get db => null;

  _recuperaDadosUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    idUsuarioLogado = usuarioLogado.uid;

  }

  Future<Stream<QuerySnapshot>?>  _adicionarListenerAnuncios() async {

   await _recuperaDadosUsuarioLogado();

   FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("meus_anuncios")
        .doc(idUsuarioLogado)
        .collection("anuncios")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
   return null;
  }

  _removerAnuncio(String idAnuncio){

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
    .doc(idUsuarioLogado)
    .collection("anuncios")
    .doc(idAnuncio)
    .delete().then((_){

      db.collection("anuncios")
          .doc(idAnuncio)
          .delete();
    });

  }


  void initState(){
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(children: [
        Text("Carregando anúncios"),
        CircularProgressIndicator(),
      ],),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Meus anuncios"),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.add),

        onPressed: () {
          Navigator.pushNamed(context,"/novo-anuncio");

        },
      ),

      body: StreamBuilder(
       stream: _controller.stream,
        builder: (context, snapshot){
         switch(snapshot.connectionState){
           case ConnectionState.none:
           case ConnectionState.waiting:
             return carregandoDados;
           case ConnectionState.active:
           case ConnectionState.done:

             if(snapshot.hasError)
               return Text("Erro ao carregar os dados!");

             QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

             return ListView.builder(
                 itemCount: querySnapshot.docs.length,
                 itemBuilder:(_, indice){
                   List<DocumentSnapshot>? anuncios = querySnapshot.docs.toList();
                   DocumentSnapshot documentSnapshot = anuncios[indice];
                   Anuncio  anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                   return itemAnuncio(
                     anuncio: anuncio,
                     onPressdRemover:(){
                       showDialog(context: context,
                           builder: (context){
                         return AlertDialog(
                           title: Text("Confirma"),
                           content: Text("Deseja excluir seu anúncio?"),
                           actions: [
                             TextButton(
                               style: ButtonStyle(
                                 foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                               ),
                               onPressed: () {
                                 Navigator.of(context).pop();
                               },
                               child: Text('Cancelar'),
                             ),

                             TextButton(
                               style: ButtonStyle(
                                 foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                               ),
                               onPressed: () {
                                 _removerAnuncio(anuncio.id);
                                 Navigator.of(context).pop();
                               },
                               child: Text('Remover'),
                             ),

                           ],
                         );
                           }
                           );
                     },
                     onTapItem: (){},
                   );
                 }
             );
         }

         return Container();

         },
      ),
    );
  }
}
