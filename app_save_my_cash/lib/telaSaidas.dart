import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'telaLogin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'telaEntradas.dart';
import 'telaMetas.dart';
import 'telaResumo.dart';

class TelaSaidas extends StatefulWidget {
  const TelaSaidas({super.key});

  @override
  State<TelaSaidas> createState() => _TelaSaidasState();
}

class _TelaSaidasState extends State<TelaSaidas> {
  DateTime _selectedDate = DateTime.now();
  final tituloController = TextEditingController();
  String? categoriaController;
  final valorController = TextEditingController();
  final dataController = TextEditingController();
  final User? user = supabase.auth.currentUser;
  List<Map<String, dynamic>> listaSaidas = [];

  @override
  void initState() {
    super.initState();
    buscarSaidas(); // fetchSaidas é chamada aqui
  }

  Future<void> deleteSaida(String idSaida) async {
    try {
      await supabase.from('saidas').delete().eq('idSaida', idSaida);
      buscarSaidas();
      showMessage(context, 'Saída excluída com sucesso!');
    } catch (e) {
      showMessage(context, 'Erro ao excluir a saída: ${e}');
    }
  }

  Future<void> atualizarSaida(String idSaida, String titulo, String categoria,
      double valor, String data) async {
    try {
      await supabase.from('saidas').update({
        'tituloSaida': titulo,
        'categoriaSaida': categoria,
        'valorSaida': valor,
        'dataSaida': data,
      }).eq('idSaida', idSaida);
      showMessage(context, "Saída atualizada com sucesso!");
      buscarSaidas();
    } catch (e) {
      showMessage(context, 'Erro ao atualizar: ${e}');
    }
  }

  Future<void> buscarSaidas() async {
    try {
      final dados =
          await supabase.from('saidas').select().eq('idUsuario', user!.id);
      setState(() {
        listaSaidas = dados as List<Map<String, dynamic>>;
      });
    } catch (e) {
      showMessage(context, "Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> buscarSaidasData(String data) async {
    try {
      final dados = await supabase
          .from('saidas')
          .select()
          .eq('idUsuario', user!.id)
          .eq('dataSaida', data);
      setState(() {
        listaSaidas = dados as List<Map<String, dynamic>>;
      });
    } catch (e) {
      showMessage(context, "Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> addSaida() async {
    if (tituloController.text.isEmpty) {
      showMessage(context, 'Insira um título!');
    } else if (categoriaController!.isEmpty) {
      showMessage(context, 'Insira uma categoria!');
    } else if (valorController.text.isEmpty) {
      showMessage(context, 'Informe um valor para a saída!');
    } else if (dataController.text.isEmpty) {
      showMessage(context, 'Informe uma data para a saída!');
    } else {
      await supabase.from('saidas').insert({
        'tituloSaida': tituloController.text,
        'categoriaSaida': categoriaController,
        'valorSaida': double.parse(valorController.text),
        'dataSaida': dataController.text,
        'idUsuario': user?.id,
      });
      buscarSaidas();
      showMessage(context, 'Saída cadastrada com sucesso!');
    }
  }

  void showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                child: Text(
                  "OK",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(48, 203, 128, 50),
                  foregroundColor: Colors.white,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selecionaDate(BuildContext context) async {
    final DateTime? selecionada = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selecionada != null && selecionada != _selectedDate) {
      setState(() {
        _selectedDate = selecionada;
        dataController.text = _formatDate(_selectedDate);
      });
    }
  }

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
    buscarSaidasData(_formatDate(_selectedDate) as String);
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> saida) {
    tituloController.text = saida['tituloSaida'];
    categoriaController = saida['categoriaSaida'];
    valorController.text = saida['valorSaida'].toString();
    dataController.text = saida['dataSaida'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar Saída"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: tituloController,
                    decoration: InputDecoration(
                      label: Text('Título da Saída:'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      label: Text('Categoria da Saída:'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                    value: categoriaController,
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
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        categoriaController = newValue;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: valorController,
                    decoration: InputDecoration(
                      label: Text('Valor gasto: R\$'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    controller: dataController,
                    decoration: InputDecoration(
                      label: Text('Data da Saída:'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await _selectDate(context);
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
                  atualizarSaida(
                      saida['idSaida'],
                      tituloController.text,
                      categoriaController!,
                      double.parse(valorController.text),
                      dataController.text);
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

  

  void _showAddDialog(BuildContext context) {
    tituloController.clear();
    valorController.clear();
    categoriaController = null;
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
                    controller: tituloController,
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
                    value: categoriaController,
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
                    onChanged: (String? newValue) {
                      setState(() {
                        categoriaController = newValue;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: valorController,
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
                    controller: dataController,
                    decoration: InputDecoration(
                      label: Text('Data da Saída:'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      /*final DateTime? selecionada = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );*/
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await _selecionaDate(context);
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
                  try {
                    addSaida();
                  } catch (e) {
                    showMessage(context, 'ERRO: ${e}');
                  }
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
                        onPressed: () {
                          print(listaSaidas);
                          buscarSaidasData(
                              _formatDate(_selectedDate) as String);
                        },
                        child: Text(
                          'Visualizar por Data',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          buscarSaidas();
                        },
                        child: Text(
                          'Visualizar Tudo',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        _decrementDate();
                        buscarSaidasData(_formatDate(_selectedDate) as String);
                      },
                      icon: Icon(
                        Icons.arrow_left_outlined,
                        size: 50,
                      ),
                    ),
                    Text(
                      '${_formatDate(_selectedDate)}',
                      style: TextStyle(fontSize: 22),
                    ),
                    IconButton(
                      onPressed: () {
                        _incrementDate();
                        buscarSaidasData(_formatDate(_selectedDate) as String);
                      },
                      icon: Icon(
                        Icons.arrow_right_outlined,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: listaSaidas.isEmpty
                      ? Center(child: Column(children: [CircularProgressIndicator(),SizedBox(height: 20,), Text('Não encontramos nenhuma saída cadastrada ainda...')] ))
                      : ListView.builder(
                          itemCount: listaSaidas.length,
                          itemBuilder: (context, index) {
                            final saida = listaSaidas[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(saida['tituloSaida']),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Categoria: ${saida['categoriaSaida']}'),
                                    Text('R\$: ${saida['valorSaida']}')
                                  ],
                                ),
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
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  onTap: () {
                                                    print('Editar');
                                                    Navigator.of(context).pop();
                                                    _showEditDialog(
                                                        context, saida);
                                                    
                                                    
                                                  },
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0)),
                                                GestureDetector(
                                                  child: Text(
                                                    'Excluir',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    print('Excluir');
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
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
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor: Color.fromRGBO(
                                                                                48,
                                                                                203,
                                                                                128,
                                                                                50),
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            deleteSaida(saida['idSaida']);
                                                                            buscarSaidas();
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text('Sim'),
                                                                        ),
                                                                        ElevatedButton(
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor: Color.fromRGBO(
                                                                                48,
                                                                                203,
                                                                                128,
                                                                                50),
                                                                            foregroundColor:
                                                                                Colors.white,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text('Não'),
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
                    _showAddDialog(context);
                    
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
