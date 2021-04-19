import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset('assets/sample-01.jpg',
                    height: 100.0, width: 100.0),
                Center(
                  child: Text('Connexion',
                      style: Theme.of(context).textTheme.headline6),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Entrez un email' : null,
                  onChanged: (val) => email = val,
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Mot de passe', border: OutlineInputBorder()),
                  validator: (val) => val!.length < 6
                      ? 'Entrez un mot de passe avec 6 ou plus'
                          'des caracteres'
                      : null,
                  onChanged: (val) => password = val,
                  obscureText: true,
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/home');
                    if (_formKey.currentState!.validate()) {
                      print('login : okay');
                    }
                  },
                  child: Text('Connexion'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text("Je n'ai pas de compte"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
