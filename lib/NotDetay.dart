import 'package:flutter/material.dart';
import 'package:notsepeti/utils/veritabani_yardimcisi.dart';

import 'models/kategori.dart';
import 'models/notlar.dart';

class NotDetay extends StatefulWidget {
  String baslik;

  NotDetay({this.baslik});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formAnahtari = GlobalKey<FormState>();
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;
  int kategoriID = 1;
  int secilenOncelik = 0;
  String notBaslik, notIcerik;
  static var _oncelikler = ["düşük", "orta", "yüksek"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumKategoriler = List<Kategori>();
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir().then((gelenKategorilerMapOlarak) {
      for (Map okunanMap in gelenKategorilerMapOlarak) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.baslik),
      ),
      body: tumKategoriler.length < 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.all(5),
              child: Form(
                key: formAnahtari,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Kategori : ",
                          style: TextStyle(fontSize: 24),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.amber, width: 5)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: kategoriItemleriOlustur(),
                              value: kategoriID,
                              onChanged: (secilen) {
                                setState(() {
                                  kategoriID = secilen;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (girilen) {
                          if (girilen.length < 3) {
                            return " En az 3 karakter olmalı";
                            // ignore: missing_return
                          }
                        },
                        onSaved: (girilen) {
                          notBaslik = girilen;
                        },
                        decoration: InputDecoration(
                            hintText: "not başlığını gir",
                            labelText: "Başlık",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (text) {
                          notIcerik = text;
                        },
                        maxLines: 4,
                        decoration: InputDecoration(
                            hintText: "içerik gir",
                            labelText: "İçerik",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Öncelik : ",
                          style: TextStyle(fontSize: 24),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.amber, width: 5)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: _oncelikler.map((oncelik) {
                                return DropdownMenuItem<int>(
                                  child: Text(
                                    oncelik,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  value: _oncelikler.indexOf(oncelik),
                                );
                              }).toList(),
                              value: secilenOncelik,
                              onChanged: (secilen) {
                                setState(() {
                                  secilenOncelik = secilen;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Vazgeç",
                              style: TextStyle(color: Colors.white)),
                          color: Colors.red,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (formAnahtari.currentState.validate()) {
                              formAnahtari.currentState.save();

                              var suan = DateTime.now();
                              print("Zaman : " + databaseHelper.dateFormat(suan));
                              databaseHelper
                                  .notEkle(Not(kategoriID, notBaslik, notIcerik,
                                      suan.toString(), secilenOncelik))
                                  .then((notId) {
                                if (notId != 0) {
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          child: Text(
                            "Ekle",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> kategoriItemleriOlustur() {
    return tumKategoriler
        .map((kategori) => DropdownMenuItem<int>(
              value: kategori.kategoriID,
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    kategori.kategoriAdi,
                    style: TextStyle(fontSize: 21),
                  )),
            ))
        .toList();
  }
}

/*
Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12 , horizontal: 40),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.amber,width: 5)),
                child: DropdownButtonHideUnderline(

                  child: tumKategoriler.length <= 0
                      ? CircularProgressIndicator()
                      : DropdownButton<int>(
                          items: kategoriItemleriOlustur(),
                          onChanged: (secilenKategoriID) {
                            setState(() {
                              secilenKategoriID = KategoriID;
                            });
                          },
                          value: KategoriID,
                        ),
                ),
              ),
            )
          ],
        ),
      )

 */
