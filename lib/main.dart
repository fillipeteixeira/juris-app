import 'package:flutter/material.dart';
import 'package:juris_app/bloc/bloc_provider.dart';
import 'package:juris_app/bloc/home_bloc.dart';
import 'package:juris_app/bloc/user_bloc.dart';
import 'package:juris_app/screens/about_screen.dart';
import 'package:juris_app/screens/login_screen.dart';
import 'package:juris_app/screens/signup_screen.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final routes = <String, WidgetBuilder>{
    AboutScreen.tag: (context) => AboutScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          primaryColor: Colors.white,
          fontFamily: 'Nunito',
        ),
        title: 'Consulta Jurisprudêncial',
        routes: routes,
        home: BlocProvider(
          bloc: HomeBloc(),
          child: BlocProvider(
            bloc: UserBloc(),
            child: LoginScreen(),
          ),
        ));
  }
}
