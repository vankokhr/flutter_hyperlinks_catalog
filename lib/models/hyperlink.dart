class UserHyperlinks {
  String? idHyperlink;
  String? descHyperlink;
  String? hyperlink;
  String? nameHyperlink;

  UserHyperlinks(
      {this.idHyperlink,
      this.descHyperlink,
      this.nameHyperlink,
      this.hyperlink});

  Map<String, dynamic> toJson() => {
        'idHyperlink': idHyperlink,
        'descHyperlink': descHyperlink,
        'hyperlink': hyperlink,
        'nameHyperlink': nameHyperlink
      };

  UserHyperlinks.fromSnapshot(snapshot)
      : descHyperlink = snapshot.data()['descHyperlink'],
        idHyperlink = snapshot.data()['idHyperlink'],
        hyperlink = snapshot.data()['hyperlink'],
        nameHyperlink = snapshot.data()['nameHyperlink'];
}
