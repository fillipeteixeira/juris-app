import 'package:flutter/material.dart';
import 'package:juris_app/bloc/bloc_provider.dart';
import 'package:juris_app/bloc/user_bloc.dart';

class SignupScreen extends StatefulWidget {
  final UserBloc bloc;
  SignupScreen({this.bloc});
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static final tag = 'signup_screen';
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  BuildContext _context;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this._context = context;

    final saveAccountButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Map<String, dynamic> userData = {
              "name": _nomeController.text,
              "email": _emailController.text
            };

            widget.bloc.signUp(
                userData: userData,
                pass: _senhaController.text,
                onSuccess: _onSuccess,
                onFail: _onFail);
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Salvar',
            style: TextStyle(color: Colors.white, fontSize: 17.0)),
      ),
    );

    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.lightBlueAccent,
                  ]),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.dstATop),
                      image: AssetImage('images/juiz.jpg'))),
            ),
            Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 48.0),
                      new Theme(
                        data: new ThemeData(
                            primaryColor: Colors.white,
                            accentColor: Colors.white,
                            hintColor: Colors.white),
                        child: new TextFormField(
                          controller: _nomeController,
                          validator: validateNome,
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                          decoration: new InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                _nomeController.text = "";
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 15.0,
                              ),
                            ),
                            labelText: 'Nome',
                            labelStyle: new TextStyle(
                                color: Colors.white, fontSize: 25.0),
                            border: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      new Theme(
                        data: new ThemeData(
                            primaryColor: Colors.white,
                            accentColor: Colors.white,
                            hintColor: Colors.white),
                        child: new TextFormField(
                          controller: _emailController,
                          validator: validateEmail,
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                          decoration: new InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                _emailController.text = "";
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 15.0,
                              ),
                            ),
                            labelText: 'E-mail',
                            labelStyle: new TextStyle(
                                color: Colors.white, fontSize: 25.0),
                            border: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      new Theme(
                        data: new ThemeData(
                            primaryColor: Colors.white,
                            accentColor: Colors.white,
                            hintColor: Colors.white),
                        child: new TextFormField(
                          controller: _senhaController,
                          validator: validateSenha,
                          style: TextStyle(color: Colors.white, fontSize: 17.0),
                          decoration: new InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                _senhaController.text = "";
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 15.0,
                              ),
                            ),
                            labelText: 'Senha',
                            labelStyle: new TextStyle(
                                color: Colors.white, fontSize: 25.0),
                            border: new UnderlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      saveAccountButton
                    ],
                  ),
                )),
              ),
            )
          ],
        ));
  }

  String validateEmail(String value) {
    if (value.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Digite um email válido';
    }
  }

  String validateSenha(String value) {
    if (value.isEmpty || value.length < 6) {
      return 'Senha inválida!';
    }
  }

  String validateNome(String value) {
    if (value.isEmpty || value.length < 2) {
      return 'Nome muito pequeno!';
    }
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(this._context).primaryColor,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(this._context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
