import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:juris_app/bloc/bloc_provider.dart';
import 'package:juris_app/model/jurisprudencia.dart';

class HomeBloc implements BlocBase {
  final StreamController<List<Jurisprudencia>> _homeController =
      StreamController<List<Jurisprudencia>>.broadcast();
  Stream get home => _homeController.stream;


  final StreamController<bool> _emptyController =
      StreamController<bool>.broadcast();
  Stream<bool> get isEmpty => _emptyController.stream;
  Sink get inEmpty => _emptyController.sink;

  @override
  void dispose() {
    _homeController.close();
  }

  void pesquisar(String search) async {
    _homeController.sink.add([]);

    http.Response response =
        await http.get("https://juris-app.herokuapp.com/api?p=$search");

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);

      List<Jurisprudencia> lista = List<Jurisprudencia>();

      json.decode(body).forEach((v) {
        lista.add(Jurisprudencia.fromJson(v));

      });

      _homeController.sink.add(lista);
      _emptyController.sink.add(!lista.isEmpty);
    } else {
      throw Exception("Falhar ao pesquisar!");
    }
  }
}
