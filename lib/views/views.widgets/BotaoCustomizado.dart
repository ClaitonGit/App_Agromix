import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  
  
  final String texto;
  final Color corTexto;
  final VoidCallback? onPressed;

  BotaoCustomizado({
    required this.texto,
    this.corTexto = Colors.white,
    this.onPressed
});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child:Text(
        this.texto,
        style: TextStyle(
          color: this.corTexto, fontSize: 22,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
        primary: Colors. orange,
      ),
      onPressed: this.onPressed,

    );
  }
}
