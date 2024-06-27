import 'package:app_save_my_cash/telaInicial.dart';
import 'package:app_save_my_cash/telaLogin.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final senhaConfirmacaoController = TextEditingController();

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

  Future<void> fazerCadastro() async {
    if (nomeController.text.isEmpty) {
      showMessage(context, 'Insira um nome válido!');
    } else if (emailController.text.isEmpty) {
      showMessage(context, 'Insira um e-mail válido!');
    } else if (senhaController.text.isEmpty) {
      showMessage(context, 'Insira uma senha válida!');
    } else if (senhaController.text != senhaConfirmacaoController.text) {
      showMessage(context, 'As senhas não conferem!');
    } else {
      try {
        final authResponse = await supabase.auth.signUp(
            password: senhaController.text, email: emailController.text);

        showMessage(context, "Login realizado com sucesso!");
        print('Login realizado com sucesso! ${authResponse}');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TelaInicial()),
        );
      } catch (e) {
        print('Erro: ${e}');
        showMessage(context, "Erro: ${e}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 221, 255, 222),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0, top: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/user.png'),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                          child: Text(
                            'Cadastre-se:',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      controller: nomeController,
                      decoration: InputDecoration(
                        label: Text('Nome'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        label: Text('Email'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      controller: senhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: TextField(
                      controller: senhaConfirmacaoController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        //final authResponse = await supabase.auth.signUp(
                        // password: senhaController.text,
                        //email: emailController.text);
                        fazerCadastro();
                      },
                      child: Text(
                        'Cadastrar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(48, 203, 128, 50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TelaLogin()),
                      );
                    },
                    child: Text(
                      'Já tem uma conta? Entrar.',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
