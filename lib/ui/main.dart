import 'package:flutter/material.dart';
import 'package:urbvan/ui/pages/home.dart';

class Urbvan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba Urbvan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}