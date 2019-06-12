import 'package:flutter/material.dart';
import 'package:playground/ui/records.dart';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => Home()
    },
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Student Records'),
        backgroundColor: Colors.purple,
      ),
      body: Records(),
    );
  }
}
