import 'package:app_save_my_cash/telaLogin.dart';
import 'package:flutter/material.dart';
import 'telaConfiguracoes.dart';
import 'telaEntradas.dart';
import 'telaMetas.dart';
import 'telaPerfil.dart';
import 'telaSaidas.dart';

class TelaResumo extends StatefulWidget {
  const TelaResumo({super.key});

  @override
  State<TelaResumo> createState() => _TelaResumoState();
}

class _TelaResumoState extends State<TelaResumo> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              ListTile(),
              ListTile(
                leading: Icon(
                  Icons.bar_chart_outlined,
                  color: Colors.blue, size: 40,
                ),
                title: Text('Resumo', style: TextStyle(fontSize: 22),),
                onTap: () {
                  print('Resumo');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaResumo()),
                    );
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.money_off_csred_outlined,
                  color: Colors.red, size: 40,
                ),
                title: Text('Saídas', style: TextStyle(fontSize: 22),),
                onTap: () {
                  print('Saídas');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaSaidas()),
                    );
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.green, size: 40,
                ),
                title: Text('Entradas', style: TextStyle(fontSize: 22),),
                onTap: () {
                  print('Entradas');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaEntradas()),
                    );
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.auto_awesome_outlined,
                  color: Colors.orange, size: 40,
                ),
                title: Text('Metas', style: TextStyle(fontSize: 22),),
                onTap: () {
                  print('Metas');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaMetas()),
                    );
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey, size: 40,
                ),
                title: Text('Configurações', style: TextStyle(fontSize: 22),),
                onTap: () {
                  print('Configurações');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaConfiguracoes()),
                    );
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.purple, size: 40,
                ),
                title: Text('Perfil', style: TextStyle(fontSize: 22),),
                onTap: () {
                  print('Perfil');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaPerfil()),
                    );
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.output_outlined,
                  color: Colors.black, size: 40,
                ),
                title: Text('Sair', style: TextStyle(fontSize: 22),),
                onTap: () {
                  print('Sair');
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TelaLogin()),
                    );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Center(
            child: Text(
              'Resumo',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Color.fromRGBO(48, 203, 128, 50),
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 221, 255, 222),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Resumo"),
                _selectedDate == null
                    ? Text('Nenhuma data selecionada!')
                    : Text('Data selecionada: ${_selectedDate.toString().split(' ')[0]}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
