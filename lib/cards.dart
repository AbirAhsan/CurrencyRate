import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  final fromTextControler = TextEditingController();

  String _fromCurrency = "EUR";
  String _toCurrency = "BDT";
  String results;
  List<String> currencies;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadCurrencies();
  }

  Future<String> loadCurrencies() async {
    var response = await http.get(Uri.encodeFull(
        'http://data.fixer.io/api/latest?access_key=548134d5d214ad70cb34ea70305d88be'));
    var responseBody = json.decode(response.body);
    Map currencyMap = responseBody["rates"];

    currencies = currencyMap.keys.toList();
    setState(() {});

    return "Success";
  }

  var _colorGreen = Colors.green;

  Future<String> doConversion() async {
    setState(() {
      loading = true;
    });
    var response = await http.get(Uri.encodeFull(
        'http://data.fixer.io/api/latest?access_key=548134d5d214ad70cb34ea70305d88be&base=$_fromCurrency&symbols=$_toCurrency'));
    var responseBody = json.decode(response.body);

    setState(() {
      results = (double.parse(fromTextControler.text) *
              (responseBody["rates"][_toCurrency]))
          .toString();
      loading = false;
      // _colorGreen = _colorGreen == Colors.green ? Colors.red : Colors.green;
    });
    print(responseBody["rates"][_toCurrency]);
    return "Success";
  }

  _fromOnChanged(String value) {
    setState(() {
      _fromCurrency = value;
    });
  }

  _toOnChanged(String value) {
    setState(() {
      _toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var _height = screenSize.height;
    var _width = screenSize.width;
    final Color colorWhite = Color.fromRGBO(239, 255, 251, 1);
    final Color colorGreen = Color.fromRGBO(80, 216, 144, 1);
    final Color colorBlue = Color.fromRGBO(79, 152, 202, 1);
    final Color colorBlack = Color.fromRGBO(39, 39, 39, 1);

    return currencies == null
        ? Align(alignment: Alignment.center, child: CircularProgressIndicator())
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusScopeNode());
            },
            child: Container(
              alignment: Alignment.center,
              width: _width,
              height: _height * 0.7,
              color: colorWhite,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: _width / 1.2,
                    height: _height * 0.572 + 10.0,
                    color: colorWhite,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: _height / 3.5,
                          width: _width / 1.2,
                          child: Card(
                            color: colorBlue,
                            elevation: 10.0,
                            child: Align(
                              alignment: Alignment.center,
                              child: ListTile(
                                title: TextFormField(
                                  cursorColor: Colors.white,
                                  controller: fromTextControler,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                    labelText: "Enter Your Amount",
                                  ),
                                ),
                                trailing: _buildDropdownButton(_fromCurrency),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          height: _height / 3.5,
                          width: _width / 1.2,
                          child: Card(
                            color: colorBlue,
                            elevation: 10.0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                textDirection: TextDirection.ltr,
                                children: <Widget>[
                                  Chip(
                                    elevation: 10.0,
                                    label: results != null
                                        ? Text(
                                            results,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                                color: colorBlack),
                                          )
                                        : Text(
                                            "0.0",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                                color: colorBlack),
                                          ),
                                  ),
                                  _buildDropdownButton(_toCurrency),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: (_width / 2.4) - (_height / 3.5 * 0.25),
                    top: (_height * 0.5) / 2.35,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.0,
                              offset: Offset(1, 5),
                              spreadRadius: 3,
                            )
                          ]),
                          child: CircleAvatar(
                            backgroundColor: loading ? Colors.red : colorGreen,
                            radius: 50.0,
                          ),
                        ),
                        loading
                            ? _iconButton()
                            : IconButton(
                                icon: Icon(Icons.arrow_downward),
                                padding: EdgeInsets.all(0),
                                iconSize: _height / 3.5 * 0.5,
                                color: Colors.red,
                                onPressed: doConversion)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _iconButton() {
    var screenSize = MediaQuery.of(context).size;
    var _height = screenSize.height;
    return IconButton(
        icon: Icon(Icons.check_circle),
        padding: EdgeInsets.all(0),
        iconSize: _height / 3.5 * 0.5,
        color: Color.fromRGBO(80, 216, 144, 1),
        onPressed: doConversion);
  }

  Widget _buildDropdownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currencies
          .map(
            (String value) => DropdownMenuItem(
              value: value,
              child: Row(
                children: <Widget>[
                  Text(
                    value,
                    style: TextStyle(
                      color: Color.fromRGBO(39, 39, 39, 1),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (String value) {
        if (currencyCategory == _fromCurrency) {
          _fromOnChanged(value);
        } else {
          _toOnChanged(value);
        }
      },
    );
  }
}
