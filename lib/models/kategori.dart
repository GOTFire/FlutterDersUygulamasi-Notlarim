class Kategori {

  int kategoriID;
  String kategoriAdi;

  Kategori(this.kategoriAdi); // kategori eklerken ID otomoatik ekleniyor DB de

  Kategori.IDli(this.kategoriID, this.kategoriAdi); // Kategorileri DB den okurken kullannılırmış

  Map<String , dynamic> toMap(){

    var map = Map<String , dynamic>();
    map["kategoriID"] = kategoriID;
    map["kategoriAdi"] = kategoriAdi;

    return map;
  }

  Kategori.fromMap(Map<String , dynamic> gelenMap){

    this.kategoriAdi = gelenMap["kategoriAdi"];
    this.kategoriID = gelenMap["kategoriID"];
  }

  @override
  String toString() {
    return 'Kategori{kategoriID: $kategoriID, kategoriAdi: $kategoriAdi}';
  }


}