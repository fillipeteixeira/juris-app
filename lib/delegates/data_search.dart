import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  bool _autorized = false;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          _autorized = true;

          query = query;
        },
      ),
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          _autorized = false;
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty)
      return Container();
    else
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: _autorized ? CircularProgressIndicator() : Text(''),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                _autorized = false;
                return Card(
                  margin: EdgeInsets.all(10.0),
                  elevation: 1,
                  child: ListTile(
                    title: Text(snapshot.data[index][2]),
                    subtitle: Text('\n' + snapshot.data[index][0] + '\n\n' + snapshot.data[index][3]),
                    onTap: () {
                      close(context, snapshot.data[index]);
                    },
                  ),
                );
              },
              itemCount: snapshot.data.length,
            );
          }
        },
      );
  }

  Future<List> suggestions(String search) async {
    if (_autorized) {
      http.Response response =
          await http.get("https://juris-app.herokuapp.com/api?p=$search");

      if (response.statusCode == 200) {
        _autorized = false;
        String body = utf8.decode(response.bodyBytes);
        return json.decode(body).map((v) {
          return v;
        }).toList();
      } else {
        throw Exception("Failed to load suggestions");
      }
    }

    _autorized = false;
  }
}
