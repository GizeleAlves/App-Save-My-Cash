import 'package:flutter/material.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  List<Widget> lista = [];
  @override
  Widget build(BuildContext context) {
    lista.add(Text('oi'));
    lista.add(Text('by'));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Página Inicial',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Color.fromRGBO(48, 203, 128, 50),
        ),
        backgroundColor: Color.fromARGB(255, 221, 255, 222),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Center(
            child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Resumo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(48, 203, 128, 50),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Bordas suavemente arredondadas
                    ),
                    
                  ),
                ),

                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Saídas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(48, 203, 128, 50),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(70, 20, 70, 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Bordas suavemente arredondadas
                    ),
                    
                  ),
                ),

                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Entradas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(48, 203, 128, 50),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Bordas suavemente arredondadas
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
