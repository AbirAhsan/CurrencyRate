import 'package:currencyrate/cards.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color colorWhite = Color.fromRGBO(239, 255, 251, 1);
    final Color colorBlue = Color.fromRGBO(79, 152, 202, 1);
    final Color colorBlack = Color.fromRGBO(39, 39, 39, 1);
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          backgroundColor: colorBlue,
          title: Text(
            "Currency Rate",
            style: TextStyle(color: colorBlack),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("Check Your Currency Rate"),
              Cards(),
            ],
          ),
        ),
      ),
    );
  }
}
