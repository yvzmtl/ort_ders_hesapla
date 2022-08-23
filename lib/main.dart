import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  String lessonName;
  int desrKredi = 1;
  double dersHarfDegeri = 4.0;
  List<Ders> allLesson;
  var formkey = GlobalKey<FormState>();
  double ortalama = 0;
  static int sayac = 0;

  @override
  void initState() {
    super.initState();
    allLesson = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Ortalama Hesaplama"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (formkey.currentState.validate()) {
            formkey.currentState.save();
          }
        },
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _appBodyDikey();
          } else {
            return _appBodyYatay();
          }
        },
      ),
    );
  }

  Widget _appBodyDikey() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            // color: Colors.pink.shade300,
            child: Form(
              key: formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Ders Adı",
                      hintText: "Ders Adını Giriniz",
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20, color: Colors.green),
                      // helperText: ("Ders adını yazınız"),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green.shade200, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green.shade300, width: 2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value.length > 0) {
                        return null;
                      } else {
                        return "Ders Adı boş bırakılamaz";
                      }
                    },
                    onSaved: (value) {
                      lessonName = value;
                      setState(() {
                        allLesson.insert(
                            0,
                            Ders(lessonName, dersHarfDegeri, desrKredi,
                                createRandomColor()));
                        ortalama = 0;
                        ortalamaHesapla();
                      });
                    },
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: _dersKredileriItems(),
                            value: desrKredi,
                            onChanged: (selectedvalue) {
                              setState(() {
                                desrKredi = selectedvalue;
                              });
                            },
                          ),
                        ),
                        margin: EdgeInsets.only(top: 10.0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.purple, width: 2.0),
                        ),
                      ),
                      // SizedBox(
                      //   width: 50,
                      // ),
                      Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                            items: _dersHarfDegerleriItems(),
                            value: dersHarfDegeri,
                            onChanged: (selectedvalue) {
                              setState(() {
                                dersHarfDegeri = selectedvalue;
                              });
                            },
                          ),
                        ),
                        margin: EdgeInsets.only(top: 10.0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.purple, width: 2.0),
                        ),
                      ),
                    ],
                  ),
                  // Divider(
                  //   color: Colors.blue,
                  //   height: 40.0,
                  //   indent: 5.0,
                  //   thickness: 1.0,
                  // ),
                ],
              ),
            ),
          ),
          Container(
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: allLesson.length == 0
                          ? "Lütfen ders ekleyiniz"
                          : "Ortalama : ",
                      style: TextStyle(color: Colors.black, fontSize: 25)),
                  TextSpan(
                      text: allLesson.length == 0
                          ? ""
                          : "${ortalama.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 60.0,
            decoration: BoxDecoration(
                border: BorderDirectional(
              bottom: BorderSide(color: Colors.blue, width: 2),
              top: BorderSide(color: Colors.blue, width: 2),
            )),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(5.0),
            color: Colors.blue.shade300,
            child: ListView.builder(
              itemBuilder: _resultList,
              itemCount: allLesson.length,
            ),
          )),
        ],
      ),
    );
  }

  Widget _appBodyYatay() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  // color: Colors.pink.shade300,
                  child: Form(
                    key: formkey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Ders Adı",
                            hintText: "Ders Adını Giriniz",
                            hintStyle: TextStyle(fontSize: 20),
                            labelStyle:
                                TextStyle(fontSize: 20, color: Colors.green),
                            // helperText: ("Ders adını yazınız"),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green.shade200, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.green.shade300, width: 2)),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          validator: (value) {
                            if (value.length > 0) {
                              return null;
                            } else {
                              return "Ders Adı boş bırakılamaz";
                            }
                          },
                          onSaved: (value) {
                            lessonName = value;
                            setState(() {
                              allLesson.insert(
                                  0,
                                  Ders(lessonName, dersHarfDegeri, desrKredi,
                                      createRandomColor()));
                              ortalama = 0;
                              ortalamaHesapla();
                            });
                          },
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  items: _dersKredileriItems(),
                                  value: desrKredi,
                                  onChanged: (selectedvalue) {
                                    setState(() {
                                      desrKredi = selectedvalue;
                                    });
                                  },
                                ),
                              ),
                              margin: EdgeInsets.only(top: 10.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: Colors.purple, width: 2.0),
                              ),
                            ),
                            // SizedBox(
                            //   width: 50,
                            // ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<double>(
                                  items: _dersHarfDegerleriItems(),
                                  value: dersHarfDegeri,
                                  onChanged: (selectedvalue) {
                                    setState(() {
                                      dersHarfDegeri = selectedvalue;
                                    });
                                  },
                                ),
                              ),
                              margin: EdgeInsets.only(top: 10.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: Colors.purple, width: 2.0),
                              ),
                            ),
                          ],
                        ),
                        // Divider(
                        //   color: Colors.blue,
                        //   height: 40.0,
                        //   indent: 5.0,
                        //   thickness: 1.0,
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: allLesson.length == 0
                                ? "Lütfen ders ekleyiniz"
                                : "Ortalama : ",
                            style:
                                TextStyle(color: Colors.black, fontSize: 25)),
                        TextSpan(
                            text: allLesson.length == 0
                                ? ""
                                : "${ortalama.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 60.0,
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                    bottom: BorderSide(color: Colors.blue, width: 2),
                    top: BorderSide(color: Colors.blue, width: 2),
                  )),
                ),
              ],
            ),
            flex: 1,
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(5.0),
            color: Colors.blue.shade300,
            child: ListView.builder(
              itemBuilder: _resultList,
              itemCount: allLesson.length,
            ),
          )),
        ],
      ),
    );
  }

  _dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];

    for (var i = 1; i <= 10; i++) {
      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i Kredi",
          style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
      ));
    }
    return krediler;
  }

  _dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];

    harfler.add(DropdownMenuItem(
      child: Text(
        "AA",
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      value: 4.0,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "BA",
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      value: 3.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "BB",
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      value: 3.0,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "CB",
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      value: 2.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "CC",
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      value: 2.0,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "DC",
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      value: 1.5,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "DD",
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      value: 1.0,
    ));
    harfler.add(DropdownMenuItem(
      child: Text(
        "FF",
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      value: 0.0,
    ));

    return harfler;
  }

  Widget _resultList(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allLesson.removeAt(index);
          ortalamaHesapla();
        });
      },
      child: Card(
        child: ListTile(
          leading: Icon(
            Icons.library_books,
            color: allLesson[index].renk,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: allLesson[index].renk,
          ),
          title: Text(
            allLesson[index].name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(allLesson[index].kredi.toString() +
              " kredi, Ders Notu = " +
              allLesson[index].note.toString()),
        ),
      ),
    );
  }



  void ortalamaHesapla() {
    double toplamNot = 0;
    double toplamkredi = 0;

    for (var oanKideger in allLesson) {
      var kredi = oanKideger.kredi;
      var harfNotu = oanKideger.note;

      toplamNot = toplamNot + (kredi * harfNotu);
      toplamkredi += kredi;
    }
    ortalama = toplamNot / toplamkredi;
  }
}

Color createRandomColor() {
  return Color.fromARGB(150 + Random().nextInt(105), Random().nextInt(255),
      Random().nextInt(255), Random().nextInt(255));
}

class Ders {
  String name;
  double note;
  int kredi;
  Color renk;

  Ders(this.name, this.note, this.kredi, this.renk);
}
