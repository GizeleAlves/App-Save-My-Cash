import 'telaLogin.dart';
import 'package:flutter/material.dart';
import 'telaConfiguracoes.dart';
import 'telaEntradas.dart';
import 'telaMetas.dart';
import 'telaPerfil.dart';
import 'telaSaidas.dart';
import 'package:intl/intl.dart';

class TelaResumo extends StatefulWidget {
  const TelaResumo({super.key});

  @override
  State<TelaResumo> createState() => _TelaResumoState();
}

class _TelaResumoState extends State<TelaResumo> {
  DateTime _selectedDate = DateTime.now();

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

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _incrementDate() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
  }

  void _decrementDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(Duration(days: 1));
    });
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
                  color: Colors.blue,
                  size: 40,
                ),
                title: Text(
                  'Resumo',
                  style: TextStyle(fontSize: 22),
                ),
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
                  color: Colors.red,
                  size: 40,
                ),
                title: Text(
                  'Saídas',
                  style: TextStyle(fontSize: 22),
                ),
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
                  color: Colors.green,
                  size: 40,
                ),
                title: Text(
                  'Entradas',
                  style: TextStyle(fontSize: 22),
                ),
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
                  color: Colors.orange,
                  size: 40,
                ),
                title: Text(
                  'Metas',
                  style: TextStyle(fontSize: 22),
                ),
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
                  color: Colors.grey,
                  size: 40,
                ),
                title: Text(
                  'Configurações',
                  style: TextStyle(fontSize: 22),
                ),
                onTap: () {
                  print('Configurações');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TelaConfiguracoes()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.purple,
                  size: 40,
                ),
                title: Text(
                  'Perfil',
                  style: TextStyle(fontSize: 22),
                ),
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
                  color: Colors.black,
                  size: 40,
                ),
                title: Text(
                  'Sair',
                  style: TextStyle(fontSize: 22),
                ),
                onTap: () async {
                  await supabase.auth.signOut();
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
              icon: Icon(
                Icons.calendar_month_outlined,
              ),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ],
        ),
        backgroundColor: Color.fromARGB(255, 221, 255, 222),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Dia',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Mês',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Ano',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'Período',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _decrementDate,
                      icon: Icon(Icons.arrow_left_outlined, size:50 ,),
                    ),
                    Text(
                      '${_formatDate(_selectedDate!)}',
                      style: TextStyle(fontSize: 22),
                    ),
                    IconButton(
                      onPressed: _incrementDate,
                      icon: Icon(Icons.arrow_right_outlined, size: 50,),
                    ),
                  ],
                ),
                Container(
                  height: 170,
                  color: Colors.grey[200],
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text('Gerando gráfico...')),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Número de cartões que você deseja exibir
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Icon(Icons.attach_money),
                          title: Text('Título da transação'),
                          subtitle: Text('Categoria\nR\$ 0,00'),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                     backgroundColor: Color.fromRGBO(48, 203, 128, 50),
                     foregroundColor: Colors.white,
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.print_rounded),
                      SizedBox(width: 8),
                      Text('Gerar relatório'),
                    ],
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
