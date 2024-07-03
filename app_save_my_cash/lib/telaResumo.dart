import 'telaLogin.dart';
import 'package:flutter/material.dart';
import 'telaEntradas.dart';
import 'telaMetas.dart';
import 'telaSaidas.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TelaResumo extends StatefulWidget {
  const TelaResumo({super.key});

  @override
  State<TelaResumo> createState() => _TelaResumoState();
}

class _TelaResumoState extends State<TelaResumo> {
  DateTime _selectedDate = DateTime.now();
  final User? user = supabase.auth.currentUser;
  List<Map<String, dynamic>> listaSaidas = [];
  List<Map<String, dynamic>> listaEntradas = [];
  List<Map<String, dynamic>> listaMetas = [];
  double totalSaidas = 0.0;
  double totalMetas = 0.0;
  double totalEntradas = 0.0;

  @override
  void initState() {
    super.initState();
    buscarSaidas();
    buscarEntradas();
    buscarMetas(); // fetchSaidas é chamada aqui
  }

  Future<void> buscarSaidasData(String data) async {
    try {
      final dados = await supabase
          .from('saidas')
          .select()
          .eq('idUsuario', user!.id)
          .eq('dataSaida', data);
      double soma = 0.0;

      setState(() {
        listaSaidas = List<Map<String, dynamic>>.from(dados);
        for (var saida in listaSaidas) {
          if (saida['valorSaida'] != null && saida['valorSaida'] is double) {
            soma += saida['valorSaida'];
          }
        }
        totalSaidas = soma;
      });
    } catch (e) {
      print("Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> buscarSaidas() async {
    try {
      final dados =
          await supabase.from('saidas').select().eq('idUsuario', user!.id);
      double soma = 0.0;

      setState(() {
        listaSaidas = List<Map<String, dynamic>>.from(dados);
        for (var saida in listaSaidas) {
          if (saida['valorSaida'] != null && saida['valorSaida'] is double) {
            soma += saida['valorSaida'];
          }
        }
        totalSaidas = soma;
      });
    } catch (e) {
      print("Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> buscarEntradas() async {
    try {
      final dados =
          await supabase.from('entradas').select().eq('idUsuario', user!.id);
      double soma = 0.0;

      setState(() {
        listaSaidas = List<Map<String, dynamic>>.from(dados);
        for (var saida in listaSaidas) {
          if (saida['valorEntrada'] != null &&
              saida['valorEntrada'] is double) {
            soma += saida['valorEntrada'];
          }
        }
        totalEntradas = soma;
      });
    } catch (e) {
      print("Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> buscarEntradasData(String data) async {
    try {
      final dados = await supabase
          .from('entradas')
          .select()
          .eq('idUsuario', user!.id)
          .eq('dataEntrada', data);
      double soma = 0.0;

      setState(() {
        listaSaidas = List<Map<String, dynamic>>.from(dados);
        for (var saida in listaSaidas) {
          if (saida['valorEntrada'] != null &&
              saida['valorEntrada'] is double) {
            soma += saida['valorEntrada'];
          }
        }
        totalEntradas = soma;
      });
    } catch (e) {
      print("Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> buscarMetas() async {
    try {
      final dados =
          await supabase.from('metas').select().eq('idUsuario', user!.id);
      double soma = 0.0;

      setState(() {
        listaSaidas = List<Map<String, dynamic>>.from(dados);
        for (var saida in listaSaidas) {
          if (saida['valorGuardado'] != null &&
              saida['valorGuardado'] is double) {
            soma += saida['valorGuardado'];
          }
        }
        totalMetas = soma;
      });
    } catch (e) {
      print("Erro ao carregar os dados: ${e}");
    }
  }

  Future<void> buscarMetasData(String data) async {
    try {
      final dados = await supabase
          .from('metas')
          .select()
          .eq('idUsuario', user!.id)
          .eq('dataDeposito', data);
      double soma = 0.0;

      setState(() {
        listaSaidas = List<Map<String, dynamic>>.from(dados);
        for (var saida in listaSaidas) {
          if (saida['valorGuardado'] != null &&
              saida['valorGuardado'] is double) {
            soma += saida['valorGuardado'];
          }
        }
        totalMetas = soma;
      });
    } catch (e) {
      print("Erro ao carregar os dados: ${e}");
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
    buscarMetasData(_formatDate(_selectedDate));
    buscarEntradasData(_formatDate(_selectedDate));
    buscarSaidasData(_formatDate(_selectedDate));
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
                        onPressed: () {
                          buscarSaidasData(_formatDate(_selectedDate));
                          buscarEntradasData(_formatDate(_selectedDate));
                          buscarMetasData(_formatDate(_selectedDate));
                          print('Saídas: R\$ ${totalSaidas}');
                          print('Entradas: R\$ ${totalEntradas}');
                          print('Metas R\$: ${totalMetas}');
                        },
                        child: Text('Vizualizar por Data',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black))),
                    TextButton(
                        onPressed: () {
                          buscarSaidas();
                          buscarEntradas();
                          buscarMetas();
                          print('Saídas: R\$ ${totalSaidas}');
                          print('Entradas: R\$ ${totalEntradas}');
                          print('Metas R\$: ${totalMetas}');
                        },
                        child: Text('Vizualizar Tudo',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        print('Diminui data');
                        _decrementDate();
                        buscarMetasData(_formatDate(_selectedDate));
                        buscarEntradasData(_formatDate(_selectedDate));
                        buscarSaidasData(_formatDate(_selectedDate));
                      },
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
                      onPressed: () {
                        print('Aumenta Data');
                        _incrementDate();
                        buscarMetasData(_formatDate(_selectedDate));
                        buscarEntradasData(_formatDate(_selectedDate));
                        buscarSaidasData(_formatDate(_selectedDate));
                      },
                      icon: Icon(
                        Icons.arrow_right_outlined,
                        size: 50,
                      ),
                    ),
                  ],
                ),
                /*Container(
                  height: 170,
                  color: Colors.grey[200],
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text('Gerando gráfico...')),
                ),*/
                Expanded(
                  child: listaSaidas.isEmpty &&
                          listaEntradas.isEmpty &&
                          listaMetas.isEmpty
                      ? Center(
                          child: Column(children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              'Não encontramos nenhuma movimentação cadastrada ainda...')
                        ]))
                      : Column(
                          children: [
                            Card(
                              child: ListTile(
                                title: Text('Total de Entradas:'),
                                subtitle: Text('R\$: ${totalEntradas}'),
                                leading: Icon(Icons.bar_chart_outlined),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TelaEntradas()),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                title: Text('Total de Saidas:'),
                                subtitle: Text('R\$: ${totalSaidas}'),
                                leading: Icon(Icons.bar_chart_outlined),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TelaSaidas()),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Card(
                              child: ListTile(
                                title: Text('Total de Economia (metas):'),
                                subtitle: Text('R\$: ${totalMetas}'),
                                leading: Icon(Icons.bar_chart_outlined),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_outlined),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TelaMetas()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                /*ElevatedButton(
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
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
