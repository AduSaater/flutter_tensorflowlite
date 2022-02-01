import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class ESP826601 extends StatefulWidget {
  @override
  _ESP826601State createState() => _ESP826601State();
}

class _ESP826601State extends State<ESP826601> {
  bool on = false;
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
  on? Icon(Icons.highlight, size: 100,color: Colors.amber,
):Icon(Icons.lightbulb_outline,size: 100,color: Colors.amber,),
RaisedButton(

onPressed: (){
dbR.child("Light").set({"Switch":!on});
  setState(() {
    on = !on;
  });
},
child: on?Text("LED ON", style: TextStyle(color:Colors.green)):Text("Led off", style: TextStyle(color: Colors.black),),

),
],
),
     ),

    );
  }
}
