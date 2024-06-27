import 'package:flutter/widgets.dart';

import 'telaLogin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'telaConfiguracoes.dart';
import 'telaEntradas.dart';
import 'telaMetas.dart';
import 'telaPerfil.dart';
import 'telaResumo.dart';

class TelaSaidas extends StatefulWidget {
  const TelaSaidas({super.key});

  @override
  State<TelaSaidas> createState() => _TelaSaidasState();
}

class _TelaSaidasState extends State<TelaSaidas> {
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

  void _showEditDialog(BuildContext context, {bool isEditing = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    decoration: InputDecoration(
                      label: Text('Título da Saída:'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: DropdownButtonFormField<String>(
                    //decoration: InputDecoration(labelText: 'Categoria da Saída'),
                    decoration: InputDecoration(
                      label: Text('Categoria da Saída:'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(),
                      ),
                    ),
                    items: <String>[
                      'Alimentação',
                      'Aluguel',
                      'Beleza',
                      'Conta de água',
                      'Conta de luz',
                      'Estudos',
                      'Internet',
                      'Saúde',
                      'Telefone',
                      'Transporte',
                      'Outros'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    decoration: InputDecoration(
                      label: Text('Valor gasto: R\$'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      label: Text('Data da Saída:'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      final DateTime? selecionada = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      // Tentar trabalhar com esta data aqui
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                child: Text('Salvar'),
                onPressed: () {
                  print('Salvo');
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(48, 203, 128, 50),
                  foregroundColor: Colors.white,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
              ),
            ),
          ],
        );
      },
    );
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
              'Saídas',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Color.fromRGBO(48, 203, 128, 50),
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _selectDate(context);
              },
              icon: Icon(Icons.calendar_month_outlined),
            )
          ],
        ),
        backgroundColor: Color.fromARGB(255, 221, 255, 222),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Dia',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Mês',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Ano',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Período',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _decrementDate,
                      icon: Icon(
                        Icons.arrow_left_outlined,
                        size: 50,
                      ),
                    ),
                    Text(
                      '${_formatDate(_selectedDate!)}',
                      style: TextStyle(fontSize: 22),
                    ),
                    IconButton(
                      onPressed: _incrementDate,
                      icon: Icon(
                        Icons.arrow_right_outlined,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10, // Número de cartões que você deseja exibir
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text('Título da Sáida'),
                          subtitle: Text('Categoria\nR\$ 0,00'),
                          //trailing: Icon(Icons.more_vert_outlined),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Text(
                                              'Editar',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            onTap: () {
                                              print('Editar');
                                              Navigator.of(context).pop();
                                              _showEditDialog(
                                                  context); // Fechar o diálogo
                                              // Adicione sua ação de edição aqui
                                            },
                                          ),
                                          Padding(padding: EdgeInsets.all(8.0)),
                                          GestureDetector(
                                            child: Text(
                                              'Excluir',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              print('Excluir');
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Tem certeza que deseja excluir?',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Color.fromRGBO(48, 203, 128, 50), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                    child: Text(
                                                                        'Sim'),
                                                                  ),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Color.fromRGBO(48, 203, 128, 50), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                    child: Text(
                                                                        'Não'),
                                                                  
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ); // Fechar o diálogo
                                              // Ainda preciso tratar a exclusão aqui
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );

                              print('clicou');
                            },
                            icon: Icon(Icons.more_vert_outlined),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    print('Cadastrar');
                    _showEditDialog(context);
                    // _showEditDialog(context);
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    size: 80,
                    color: Color.fromRGBO(48, 203, 128, 50),
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
