import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Create a Form widget.
class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class User {
  String email;
  String password;
  User({this.email, this.password});
}

// Create a corresponding State class.
// This class holds data related to the form.
class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _user = User();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              _user.email = value;

              if (value == null || value.isEmpty) {
                return 'Veuillez entrer votre adresse email';
              }
              return value = '';
            },
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Mot de passe',
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              _user.password = value;

              if (value == null || value.isEmpty) {
                return 'Entrez un mot de passe';
              }
              return value = '';
            },
          ),
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Confirmation du mot de passe',
            ),
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }

              if (value != _user.password) {
                return 'Mot de passe invalide';
              }

              return value = '';
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  print(_user.email);
                  print(_user.password);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
