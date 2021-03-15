class Parametre {
  String serveur;
  String port;
  String instance;
  String societe;

  Parametre({this.serveur, this.port, this.instance, this.societe});

  Parametre.fromJson(Map<String, dynamic> json) {
    serveur = json['serveur'];
    port = json['port'];
    instance = json['instance'];
    societe = json['societe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serveur'] = this.serveur;
    data['port'] = this.port;
    data['instance'] = this.instance;
    data['societe'] = this.societe;
    return data;
  }
}