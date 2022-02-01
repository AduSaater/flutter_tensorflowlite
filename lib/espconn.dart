import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class ESP8266 extends StatefulWidget {
  @override
  _ESP8266State createState() => _ESP8266State();
}
class _ESP8266State extends State<ESP8266> {
//  bool on = false;
  final dbR = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ESP01'),
      ),
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.text_fields),
            RaisedButton(

              onPressed: (){
                dbR.child("Banana").set({"Method":"Artificially"});

              },

            ),
          ],
        ),
      ),

    );
  }
}
