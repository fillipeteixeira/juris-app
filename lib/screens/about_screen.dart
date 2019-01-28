import 'package:flutter/material.dart';
import 'package:juris_app/utils/app_constant.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  static final tag = 'about_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
        title: Text("Sobre o app", style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.bug_report, color: Colors.black),
                      title: Text("Achou algum erro?"),
                      subtitle: Text("Reporte-nos para que possamos melhorar"),
                    ),
                    ListTile(
                      leading: Icon(Icons.update, color: Colors.black),
                      title: Text("Versão"),
                      subtitle: Text("1.0.0"),
                    )
                  ],
                ),
              ),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                      child: Text("Autor",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: FONT_MEDIUM)),
                    ),
                    ListTile(
                      leading:
                      Icon(Icons.perm_identity, color: Colors.black),
                      title: Text("javapontocom"),
                    ),

                    ListTile(
                        leading: Icon(Icons.email, color: Colors.black),
                        title: Text("Envie-nos um Email"),
                        subtitle: Text("javapontocom@hotmail.com"),
                        onTap: () => launch(EMAIL_URL)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
