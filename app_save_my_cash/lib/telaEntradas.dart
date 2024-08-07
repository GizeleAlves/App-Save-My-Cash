import 'telaLogin.dart';
import 'package:flutter/material.dart';
import 'telaMetas.dart';
import 'telaResumo.dart';
import 'telaSaidas.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaEntradas extends StatefulWidget {
  const TelaEntradas({super.key});

  @override
  State<TelaEntradas> createState() => _TelaEntradasState();
}

class _TelaEntradasState extends State<TelaEntradas> {
  DateTime _selectedDate = DateTime.now();
  final tituloController = TextEditingController();
  String? categoriaController;
  final valorController = TextEditingController();
  final dataController = TextEditingController();
  final User? user = supabase.auth.currentUser;
  List<Map<String, dynamic>> listaEntradas = [];

  @override
  void initState() {
    super.initState();
    buscarEntradas();
  }

  Future<void> deleteEntrada(String idEntrada) async {
    try {
      await supabase.from('entradas').delete().eq('idEntrada', idEntrada);
      buscarEntradas();
      showMessage(context, 'Entrada excluída com sucesso!');
    } catch (e) {
      showMessage(context, 'Erro ao excluir a entrada: ${e}');
    }
  }

  Future<void> buscarEntradas() async {
    try {
      final dados =
          await supabase.from('entradas').select().eq('idUsuario', user!.id);
      setState(() {
        listaEntradas = dados as List<Map<String, dynamic>>;
      });
    } catch (e) {
      showMessage(context, "Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> buscarEntradasData(String data) async {
    try {
      final dados = await supabase
          .from('entradas')
          .select()
          .eq('idUsuario', user!.id)
          .eq('dataEntrada', data);
      setState(() {
        listaEntradas = dados as List<Map<String, dynamic>>;
      });
    } catch (e) {
      showMessage(context, "Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> addEntrada() async {
    if (tituloController.text.isEmpty) {
      showMessage(context, 'Insira um título!');
    } else if (categoriaController!.isEmpty) {
      showMessage(context, 'Insira uma categoria!');
    } else if (valorController.text.isEmpty) {
      showMessage(context, 'Informe um valor para a entrada!');
    } else if (dataController.text.isEmpty) {
      showMessage(context, 'Informe uma data para a entrada!');
    } else {
      await supabase.from('entradas').insert({
        'tituloEntrada': tituloController.text,
        'categoriaEntrada': categoriaController,
        'valorEntrada': double.parse(valorController.text),
        'dataEntrada': dataController.text,
        'idUsuario': user?.id,
      });
      buscarEntradas();
      showMessage(context, 'Entrada cadastrada com sucesso!');
    }
  }

  Future<void> atualizarEntrada(String idEntrada, String titulo,
      String categoria, double valor, String data) async {
    try {
      await supabase.from('entradas').update({
        'tituloEntrada': titulo,
        'categoriaEntrada': categoria,
        'valorEntrada': valor,
        'dataEntrada': data,
      }).eq('idEntrada', idEntrada);
      showMessage(context, "Entrada atualizada com sucesso!");
      buscarEntradas();
    } catch (e) {
      showMessage(context, 'Erro ao atualizar: ${e}');
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
    buscarEntradasData(_formatDate(_selectedDate) as String);
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

  void _showEditDialog(BuildContext context, Map<String, dynamic> entrada) {
    tituloController.text = entrada['tituloEntrada'];
    categoriaController = entrada['categoriaEntrada'];
    valorController.text = entrada['valorEntrada'].toString();
    dataController.text = entrada['dataEntrada'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar Entrada"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: tituloController,
                    decoration: InputDecoration(
                      label: Text('Título da Entrada:'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      label: Text('Categoria da Entrada:'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                    value: categoriaController,
                    items: <String>[
                      'Investimentos',
                      'Recebimento de Dívidas',
                      'Renda Extra',
                      'Salário',
                      'Outros',
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
                      label: Text('Valor recebido: R\$'),
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
                      label: Text('Data da Entrada:'),
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
                  atualizarEntrada(
                      entrada['idEntrada'],
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
    setState(() {
    // Limpa os controladores dos campos
    tituloController.clear();
    valorController.clear();
    categoriaController = null;
  });
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
                      label: Text('Título da Entrada:'),
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
                      label: Text('Categoria da Entrada:'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(),
                      ),
                    ),
                    value: categoriaController,
                    items: <String>[
                      'Cahsback'
                      'Investimentos',
                      'Recebimento Dívidas',
                      'Renda Extra',
                      'Salário',
                      'Outros',
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
                      label: Text('Valor recebido: R\$'),
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
                      label: Text('Data da Entrada:'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
        
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
                    addEntrada();
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
                  print('Sair');
                  await supabase.auth.signOut();
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
              'Entradas',
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
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          print(listaEntradas);
                          buscarEntradasData(
                              _formatDate(_selectedDate) as String);
                        },
                        child: Text(
                          'Visualizar por Data',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          buscarEntradas();
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
                        buscarEntradasData(
                            _formatDate(_selectedDate) as String);
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
                        buscarEntradasData(
                            _formatDate(_selectedDate) as String);
                      },
                      icon: Icon(
                        Icons.arrow_right_outlined,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: listaEntradas.isEmpty
                      ? Center(
                          child: Column(children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              'Não encontramos nenhuma entrada cadastrada ainda...')
                        ]))
                      : ListView.builder(
                          itemCount: listaEntradas.length,
                          itemBuilder: (context, index) {
                            final entrada = listaEntradas[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(entrada['tituloEntrada']),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Categoria: ${entrada['categoriaEntrada']}'),
                                    Text('R\$: ${entrada['valorEntrada']}')
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
                                                        context, entrada);
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
                                                                            deleteEntrada(entrada['idEntrada']);
                                                                            buscarEntradas();
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
