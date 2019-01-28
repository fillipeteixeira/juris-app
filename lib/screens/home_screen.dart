import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:juris_app/bloc/bloc_provider.dart';
import 'package:juris_app/bloc/home_bloc.dart';
import 'package:juris_app/bloc/user_bloc.dart';
import 'package:juris_app/screens/about_screen.dart';
import 'package:juris_app/model/jurisprudencia.dart';

class HomeScreen extends StatefulWidget {
  final HomeBloc bloc;
  final BuildContext loginContext;
  HomeScreen({this.bloc, this.loginContext});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  static const List<String> choices = <String>['Sobre'];

  final FocusNode _searchFocus = new FocusNode();
  bool _carregando = false;

  void choiceAction(String choice, BuildContext context) {
    if (choice == 'Sobre') {
      Navigator.of(context).pushNamed(AboutScreen.tag);
    }
  }

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(onChange);
  }

  void onChange() {
    if (!_searchFocus.hasFocus) {
      if (_searchController.text.trim().isEmpty) {
        return;
      }
      widget.bloc.inEmpty.add(true);
      setState(() {
        _carregando = true;
      });
      widget.bloc.pesquisar(_searchController.text);
    }

    /*_controller.selection = new TextSelection(
        baseOffset: newText.length,
        extentOffset: newText.length
    );*/
  }

  @override
  void dispose() {
    Navigator.of(context).pop();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
              actions: <Widget>[
                StreamBuilder<bool>(
                    initialData: false,
                    stream: widget.bloc.isEmpty,
                    builder: (cont, snap) {
                      return !snap.data
                          ? Container()
                          : IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                widget.bloc.inEmpty.add(!snap.data);
                              },
                            );
                    }),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (item) => choiceAction(item, context),
                  itemBuilder: (BuildContext context) {
                    return choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              ],
              title: Text(
                'Pesquisa',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Column(children: <Widget>[
              StreamBuilder<bool>(
                  initialData: false,
                  stream: widget.bloc.isEmpty,
                  builder: (cont, snap) {
                    if (!snap.data /*isEmpty*/) {
                      //se vazio deve aparecer
                      return Padding(
                        padding: EdgeInsets.all(5.0),
                        child: TextField(
                          focusNode: _searchFocus,
                          controller: _searchController,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22.0)),
                              filled: true,
                              fillColor: Colors.grey[300],
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[500],
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _searchController.text = "";
                                },
                                icon:
                                    Icon(Icons.close, color: Colors.grey[500]),
                              ),
                              hintText: 'Informe o tema da jurisprudência'),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
              Expanded(
                  child: StreamBuilder<List<Jurisprudencia>>(
                      stream: widget.bloc.home,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data.length > 0) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.all(10.0),
                                  elevation: 1,
                                  child: ListTile(
                                    title: Text(snapshot.data[index].titulo),
                                    subtitle: Text('\n' +
                                        snapshot.data[index].data +
                                        '\n\n' +
                                        snapshot.data[index].ementa),
                                  ),
                                );
                              });
                        } else {
                          if (_carregando) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Container();
                          }
                        }
                      }))
              /**/
            ])));
  }
}
