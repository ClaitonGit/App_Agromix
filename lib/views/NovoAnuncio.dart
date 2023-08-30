import 'dart:io' as io;
import 'package:agromix/util/Configuracoes.dart';
import 'package:agromix/views/views.widgets/BotaoCustomizado.dart';
import 'package:agromix/views/views.widgets/inputCustomizado.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/Anuncio.dart';



class NovoAnuncio extends StatefulWidget {
  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final List<io.File> _listaImagens = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  final _formKey = GlobalKey<FormState>();
  late Anuncio _anuncio;
  late BuildContext _dialogContext;


  final picker = ImagePicker();

  String? _itemSelecionaEstado;
  String? _itemSelecionaCategoria;


  _selecionarImagemGaleria() async {

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (io.File(pickedFile!.path) != null) {
      setState(() {
        _listaImagens.add(io.File(pickedFile.path));
      });
    }
  }

  _abrirDialog(BuildContext context){
    
    showDialog(
        context: context,
        barrierDismissible: false,
        builder:(BuildContext context){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              CircularProgressIndicator(),
              SizedBox(height: 20,),
              Text("Salvando anuncio....")
            ],),
          );
        }
    );
  }

  _salvarAnuncio() async {

    _abrirDialog(_dialogContext);

    // upload de imagens no storage
    await _uploadImagens();

    // salvar o anuncio
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    String idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
    .doc(idUsuarioLogado)
    .collection("anuncios")
    .doc(_anuncio.id)
    .set(_anuncio.toMap()).then((_){

      db.collection("anuncios")
      .doc(_anuncio.id)
      .set(_anuncio.toMap()).then((_){
        Navigator.pop(_dialogContext);
        Navigator.pop(context);
      });
    });
  }

  Future _uploadImagens() async {

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference pastaRaiz = storage.ref();

    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
      Reference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_anuncio.id)
          .child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem);
      String url = await uploadTask.then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
      _anuncio.fotos.add(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _CarregarItensDropdow();
    _anuncio = Anuncio.gerarId();
  }

  _CarregarItensDropdow() {
    //Categorias
   _listaItensDropCategorias = Configuracoes.getCategorias();

    //Estados
   _listaItensDropEstados = Configuracoes.getEstados();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: const Text("Novo anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //Imagens
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens?.length == 0) {
                      return "Selecione as imagens!";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length + 1,
                              itemBuilder: (context, indice) {
                                if (indice == _listaImagens.length) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selecionarImagemGaleria();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[400],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                color: Colors.grey[100],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (_listaImagens.length > 0) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Image.file(_listaImagens[
                                                          indice]),
                                                      TextButton(
                                                        child: Text("Excluir"),
                                                        onPressed: () {
                                                          setState(() {
                                                            _listaImagens
                                                                .removeAt(indice);
                                                            Navigator.of(context)
                                                                .pop();
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            FileImage(_listaImagens[indice]),
                                        child: Container(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                //Menu dropdown
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionaEstado,
                          hint: Text("Região"),
                          onSaved: (String? estado) {
                            _anuncio.estado = estado ?? "";
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaItensDropEstados,
                          validator: (valor){

                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionaEstado = valor as String?;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionaCategoria,
                          hint: Text("Categorias"),
                          onSaved: (String? categoria) {
                            _anuncio.categoria = categoria ?? "";
                          },
                          style: TextStyle(color: Colors.black, fontSize: 20),
                          items: _listaItensDropCategorias,
                          validator: (valor) {

                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionaCategoria = valor as String?;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15,),
                  child: inputCustomizado(
                    hint: "Título",
                    onSaved: (titulo) {
                      _anuncio.titulo = titulo!;
                    },
                    validator: (valor) {

                    },
                    controller: TextEditingController(),
                    maxLines: 1,
                    inputFormatters: [], inputFormaterrs: [],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    bottom: 15,
                  ),
                  child: inputCustomizado(
                    hint: "Preço",
                    onSaved: (preco) {
                      _anuncio.preco = preco!.replaceAll("R\$", "");
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true)
                    ],
                    validator: (valor) {

                    },
                    controller: TextEditingController(),
                    maxLines: 1, inputFormaterrs: [],
                  ),
                ),

                Padding(padding: EdgeInsets.only(bottom: 15,),
                  child: inputCustomizado(
                    hint: "Telefone",
                    onSaved: (telefone) {
                      _anuncio.telefone = telefone!;
                    },
                    type: TextInputType.phone,
                    validator: (valor) {

                    },
                    controller: TextEditingController(),
                    maxLines: 1,
                    inputFormaterrs: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ], inputFormatters: [],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    bottom: 15,
                  ),
                  child: inputCustomizado(
                    hint: "Descrição",
                    onSaved: (descricao) {
                      _anuncio.descricao = descricao!;
                    },
                    validator: (valor) {

                    },
                    controller: TextEditingController(),
                    maxLines: 3,
                    inputFormaterrs: [], inputFormatters: [],
                  ),
                ),

                BotaoCustomizado(
                  texto: "Cadastrar anúncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      //salva os campos
                      _formKey.currentState!.save();

                      // configura dialog context
                      _dialogContext = context;

                      _salvarAnuncio();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
