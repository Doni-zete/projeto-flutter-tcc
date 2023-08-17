import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistroPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _register(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user != null) {
        // Registration success
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Sucesso!"),
              content: const Text("Seu registro foi concluído com sucesso."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // Registration failed
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erro de Registro"),
            content: const Text("Não foi possível concluir o registro."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF7A00),
        title: const Text('Registro'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 30),
          Image.asset(
            'assets/checklist.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () => _register(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text("Registrar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
