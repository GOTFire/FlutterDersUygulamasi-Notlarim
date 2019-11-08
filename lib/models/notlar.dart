class Not{

  int notID;
  int kategoriID;
  String kategoriBaslik;
  String notBaslik;
  String notIcerik;
  String notTarih;
  int notOncelik;

  //yazarken
  Not(this.kategoriID, this.notBaslik, this.notIcerik,
      this.notTarih, this.notOncelik);

  //okurken
  Not.IDli(this.notID, this.kategoriID, this.notBaslik, this.notIcerik,
      this.notTarih, this.notOncelik);

  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();
    map["notID"] = notID;
    map["kategoriID"] = kategoriID;
    map["notBaslik"] = notBaslik;
    map["notIcerik"] = notIcerik;
    map["notTarih"]  = notTarih;
    map["notOncelik"] = notOncelik;
    return map;
  }

  Not.froMap(Map<String, dynamic> gelenMap){
    this.notID = gelenMap["notID"];
    this.kategoriID = gelenMap["kategoriID"];
    this.kategoriBaslik = gelenMap["kategoriBaslik"];
    this.notBaslik =  gelenMap["notBaslik"];
    this.notIcerik =  gelenMap["notIcerik"];
    this.notTarih =   gelenMap["notTarih"];
    this.notOncelik = gelenMap["notOncelik"];
  }

  @override
  String toString() {
    return 'Not{notID: $notID, kategoriID: $kategoriID, notBaslik: $notBaslik, notIcerik: $notIcerik, notTarih: $notTarih, notOncelik: $notOncelik}';
  }


}