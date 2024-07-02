import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'telaLogin.dart';
import 'telaEntradas.dart';
import 'telaResumo.dart';
import 'telaSaidas.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaMetas extends StatefulWidget {
  const TelaMetas({super.key});

  @override
  State<TelaMetas> createState() => _TelaMetasState();
}

class _TelaMetasState extends State<TelaMetas> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> listaMetas = [];
  final objetivoController = TextEditingController();
  final valorEstipuladoController = TextEditingController();
  final dataConclusaoController = TextEditingController();
  final dataDepositoController = TextEditingController();
  final valorGuardadoController = TextEditingController();
  final User? user = supabase.auth.currentUser;

  @override
  void initState() {
    super.initState();
    buscarMetas();
  }

  Future<void> buscarMetas() async {
    print('função buscar');
    try {
      final dados =
          await supabase.from('metas').select().eq('idUsuario', user!.id);
      setState(() {
        listaMetas = dados as List<Map<String, dynamic>>;
      });
    } catch (e) {
      showMessage(context, "Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> deletarMeta(String idMeta) async {
    print('função deletar');
    try {
      await supabase.from('metas').delete().eq('idMeta', idMeta);
      buscarMetas();
      showMessage(context, 'Meta excluída com sucesso!');
    } catch (e) {
      showMessage(context, 'Erro ao excluir a meta: ${e}');
    }
  }

  Future<void> addMeta() async {
    print('função adicionar');
    if (objetivoController.text.isEmpty) {
      showMessage(context, 'Insira um objetivo!');
    } else if (valorEstipuladoController.text.isEmpty) {
      showMessage(context, 'Estipule um valor para a meta!');
    } else if (dataConclusaoController.text.isEmpty) {
      showMessage(context, 'Estipule uma data de conclusão para a meta!');
    } else if (valorGuardadoController.text.isEmpty) {
      showMessage(context, 'Informe um valor para ser guardado!');
    } else {
      try {
        await supabase.from('metas').insert({
          'objetivoMeta': objetivoController.text,
          'valorEstipulado': double.parse(valorEstipuladoController.text),
          'dataConclusao': dataConclusaoController.text,
          'dataDeposito': _formatDate(DateTime.now()),
          'valorGuardado': double.parse(valorGuardadoController.text),
          'idUsuario': user?.id,
        });
        buscarMetas();
        showMessage(context, 'Meta cadastrada com sucesso!');
      } catch (e) {
        showMessage(context, 'Erro ao cadastrar: ${e}');
      }
    }
  }

  Future<void> editarMeta(
      String idMeta,
      String objetivo,
      double valorEstipulado,
      String dataConclusao,
      double valorGuardado) async {
    print('funçãoeditar');
    try {
      await supabase.from('metas').update({
        'objetivoMeta': objetivo,
        'valorEstipulado': valorEstipulado,
        'dataConclusao': dataConclusao,
        'valorGuardado': valorGuardado,
      }).eq('idMeta', idMeta);
      showMessage(context, "Meta atualizada com sucesso!");
      buscarMetas();
    } catch (e) {
      showMessage(context, 'Erro ao atualizar: ${e}');
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
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
        dataConclusaoController.text = _formatDate(_selectedDate);
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
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> metas) {
    objetivoController.text = metas['objetivoMeta'];
    valorEstipuladoController.text = metas['valorEstipulado'].toString();
    dataConclusaoController.text = metas['dataConclusao'];
    valorGuardadoController.text = metas['valorGuardado'].toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Editar Meta"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: objetivoController,
                    decoration: InputDecoration(
                      label: Text('Objetivo da Meta:'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: valorEstipuladoController,
                    decoration: InputDecoration(
                      label: Text('Valor Estipulado: R\$'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    controller: dataConclusaoController,
                    decoration: InputDecoration(
                      label: Text('Data da Conclusão:'),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: valorGuardadoController,
                    decoration: InputDecoration(
                      label: Text('Valor Guardado: R\$'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                    keyboardType: TextInputType.number,
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
                  editarMeta(
                      metas['idMeta'],
                      objetivoController.text,
                      double.parse(valorEstipuladoController.text),
                      dataConclusaoController.text,
                      double.parse(valorGuardadoController.text));

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
      objetivoController.clear();
      valorEstipuladoController.clear();
      valorGuardadoController.clear();
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
                    controller: objetivoController,
                    decoration: InputDecoration(
                      label: Text('Objetivo da Meta:'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: valorEstipuladoController,
                    decoration: InputDecoration(
                      label: Text('Valor Estipulado: R\$'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    controller: dataConclusaoController,
                    decoration: InputDecoration(
                      label: Text('Data da Conclusão:'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await _selecionaDate(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextField(
                    controller: valorGuardadoController,
                    decoration: InputDecoration(
                      label: Text('Valor Guardado: R\$'),
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.only()),
                    ),
                    keyboardType: TextInputType.number,
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
                    addMeta();
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
              'Metas',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Color.fromRGBO(48, 203, 128, 50),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 221, 255, 222),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  'Suas metas:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: listaMetas.isEmpty
                      ? Center(
                          child: Column(children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Não encontramos nenhuma entrada meta ainda...')
                        ]))
                      : ListView.builder(
                          itemCount: listaMetas.length,
                          itemBuilder: (context, index) {
                            final metas = listaMetas[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Center(child: Text(metas['objetivoMeta'])),
                                subtitle: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Meta: R\$ ${metas['valorEstipulado']}'),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Guardado: R\$ ${metas['valorGuardado']}'),
                                      ],
                                    ),
                                  ],
                                ),
                                leading: Icon(Icons.assignment_outlined),
                                trailing: IconButton(
                                  icon: Icon(Icons.more_vert_outlined),
                                  onPressed: () {
                                    print('Mais opções');
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
                                                        context, metas);
                                                    buscarMetas();
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
                                                                            deletarMeta(metas['idMeta']);
                                                                            buscarMetas();
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
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
                IconButton(
                  onPressed: () {
                    print("Cadastrar meta");
                    _showAddDialog(context);
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                    size: 80,
                    color: Color.fromRGBO(48, 203, 128, 50),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
