import 'package:flutter/material.dart';
import 'package:juris_app/bloc/bloc_provider.dart';
import 'package:juris_app/bloc/home_bloc.dart';
import 'package:juris_app/screens/home_screen.dart';
import 'package:juris_app/screens/signup_screen.dart';
import 'package:juris_app/bloc/user_bloc.dart';
import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';

class LoginScreen extends StatelessWidget {
  BuildContext _context;
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    this._context = context;
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _senhaController = TextEditingController();
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    final avatar = CircleAvatar(
      backgroundImage: AssetImage('images/balance.png'),
      backgroundColor: Colors.transparent,
      radius: 68.0,
    );

    final createAccountButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: OutlineButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SignupScreen(bloc: userBloc)));
        },
        child: Text('Criar conta',
            style: TextStyle(color: Colors.white, fontSize: 17.0)),
        borderSide: BorderSide(color: Colors.white),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 55.0,
        width: 160.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              userBloc.signIn(
                  email: _emailController.text,
                  pass: _senhaController.text,
                  onSuccess: _onSuccess,
                  onFail: _onFail);
            }
          },
          padding: EdgeInsets.all(12),
          color: Colors.lightBlueAccent,
          child: Text('Entrar',
              style: TextStyle(color: Colors.white, fontSize: 20.0)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Esqueceu sua senha?',
        style: TextStyle(color: Colors.black54, fontSize: 20.0),
      ),
      onPressed: () {
        if (_emailController.text.isEmpty) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Insira seu e-mail para recuperação!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ));
        } else {
          userBloc.recoverPass(_emailController.text);
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Confira seu e-mail!"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 2),
          ));
        }
      },
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
              child: StreamBuilder<bool>(
                  initialData: false,
                  stream: userBloc.isLoading,
                  builder: (context, snapshot) {
                    return Center(
                      child: SingleChildScrollView(
                          child: Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            avatar,
                            SizedBox(height: 48.0),
                            Theme(
                              data: new ThemeData(
                                  primaryColor: Colors.white,
                                  accentColor: Colors.white,
                                  hintColor: Colors.white),
                              child: new TextFormField(
                                controller: _emailController,
                                validator: validarEmail,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                                decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  hintText: 'E-mail',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Theme(
                              data: new ThemeData(
                                  primaryColor: Colors.white,
                                  accentColor: Colors.white,
                                  hintColor: Colors.white),
                              child: new TextFormField(
                                controller: _senhaController,
                                validator: validarSenha,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17.0),
                                decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.white,
                                  ),
                                  hintText: 'Senha',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: snapshot.data
                                  ? [
                                      CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      )
                                    ]
                                  : <Widget>[
                                      loginButton,
                                      SizedBox(width: 10.0),
                                      createAccountButton
                                    ],
                            ),
                            forgotLabel
                          ],
                        ),
                      )),
                    );
                  }),
            )
          ],
        ));
  }

  String validarEmail(String value) {
    if (value.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Digite um email válido';
    }
  }

  String validarSenha(String value) {
    if (value.isEmpty || value.length < 6) {
      return 'Senha inválida!';
    }
  }

  void _onSuccess() {
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(this._context);
    Navigator.of(this._context).push(MaterialPageRoute(
        builder: (context) =>
            HomeScreen(bloc: homeBloc, loginContext: _context)));
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao logar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
