

class Jurisprudencia{
  String titulo;
  String url;
  String data;
  String ementa;
  String encontrado;

  Jurisprudencia(this.titulo, this.url, this.data, this.ementa, this.encontrado);

  factory Jurisprudencia.fromJson(List<dynamic> json){
    return Jurisprudencia(json[0],
    json[1],
    json[2],
    json[3],
    json[4]);
  }

}