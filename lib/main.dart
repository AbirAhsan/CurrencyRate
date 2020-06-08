import 'package:flutter/material.dart';

import 'homepage.dart';

void main() => runApp(CurrencyRate());
class CurrencyRate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Currency Rate",
      home: HomePage(),
    );
  }
}