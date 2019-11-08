import 'package:flutter/material.dart';
import 'package:notsepeti/NotDetay.dart';
import 'package:notsepeti/models/kategori.dart';
import 'package:notsepeti/utils/veritabani_yardimcisi.dart';

import 'models/notlar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Not sepeti",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.amber),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scaffoldAnahtar = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldAnahtar,
      appBar: AppBar(
        title: Center(child: Text("Notlarr")),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              heroTag: "KAtegori Ekle",
              mini: true,
              tooltip: "Kategori Ekle",
              onPressed: () {
                kategoriEkleDialog(context);
              },
              child: Icon(Icons.category),
            ),
          ),
          FloatingActionButton(
            heroTag: "Not ekle",
            onPressed: () {
              _detaySayfasiniAc(context);
            },
            tooltip: "Not ekle",
            child: Icon(Icons.add),
          )
        ],
      ),
      body: Notlar(),
    );
  }

  void kategoriEkleDialog(BuildContext context) {
    var formAnahtar = GlobalKey<FormState>();
    String yeniKategoriAdi;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Kategori Ekle",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: <Widget>[
              Form(
                key: formAnahtar,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (deger) {
                      yeniKategoriAdi = deger;
                    },
                    validator: (girilen) {
                      if (girilen.length < 3) {
                        return "en az 4 karakter gir";
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Kategori Adi",
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.amber,
                    child: Text("Vazgeç"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (formAnahtar.currentState.validate()) {
                        formAnahtar.currentState.save();
                        databaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi))
                            .then((kategoriID) {
                          if (kategoriID > 0) {
                            _scaffoldAnahtar.currentState.showSnackBar(SnackBar(
                              content: Text("başarıyla eklendi ID $kategoriID"),
                              duration: Duration(seconds: 2),
                            ));
                          }
                          Navigator.pop(context);
                        });
                      }
                    },
                    color: Colors.green,
                    child: Text("Kaydet"),
                  )
                ],
              )
            ],
          );
        });
  }

  void _detaySayfasiniAc(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
                  baslik: "Yeni Not",
                )));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  List<Not> tumNotlar;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumNotlar = List<Not>();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Not>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          tumNotlar = snapshot.data;

          return ListView.builder(
                  itemCount: tumNotlar.length,
                  itemBuilder: (context, index) {
                    debugPrint(tumNotlar[index].kategoriBaslik);
                    return ListTile(
                      title: Text(tumNotlar[index].notBaslik),
                      //subtitle: Text(tumNotlar[index].kategoriBaslik),
                    );
                  });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
