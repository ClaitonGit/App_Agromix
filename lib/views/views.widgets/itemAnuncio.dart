import 'package:agromix/models/Anuncio.dart';
import 'package:flutter/material.dart';

class itemAnuncio extends StatelessWidget {

   Anuncio? anuncio;
   VoidCallback? onTapItem;
   VoidCallback? onPressdRemover;

  itemAnuncio({
    @required this.anuncio,
    this.onTapItem,
    this.onPressdRemover
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(children: <Widget>[

            SizedBox(
              width: 120,
              height: 120,
              child:Image.network(
                anuncio!.fotos[0],
                fit: BoxFit.cover,
              ),
            ),
          if(this.onPressdRemover != null)  Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       anuncio!.titulo,
                      style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("R\$ ${anuncio!.preco}"),
                  ],),
              ),
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: this.onPressdRemover,
                child: Icon(Icons.delete, color: Colors.white,),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  backgroundColor: Colors.red,
                ),
              ),
              )
          ],),
        ),
      ),

    );
  }
}
