import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
class ESP01 extends StatefulWidget {
  @override
  _ESP01State createState() => _ESP01State();
}

class _ESP01State extends State<ESP01> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web Socket'),

      ),
      body: WebSocketExample(),
    );
  }
}
class WebSocketExample extends StatefulWidget {
  final WebSocketChannel channel = IOWebSocketChannel.connect("ws://192.168.4.1");
  @override
  _WebSocketExampleState createState() => _WebSocketExampleState(channel:channel);
}

class _WebSocketExampleState extends State<WebSocketExample> {
 final WebSocketChannel channel;
  final inputController = TextEditingController();
 List<String> messageList = [];
 _WebSocketExampleState({this.channel}){
   channel.stream.listen((data){
     setState(() {
       messageList.add(data);
     });
   });
 }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      labelText: 'Send Text',
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text('Send',
                    style: TextStyle(fontSize: 20.0,),
                    ),
                    onPressed: (){
                      if(inputController.text.isNotEmpty){
                        channel.sink.add(inputController.text);
                        inputController.text = '';
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: getMessageList(),
          ),
        ],
      ),
    );
  }
  ListView getMessageList(){
    List<Widget> listWidget = [];
    for (String messsage in messageList){
      listWidget.add(ListTile(
        title: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              messsage, style: TextStyle(fontSize: 18),
            ),
          ),
          color: Colors.teal[50],
          height: 60,
        ),
      ));
    }
    return ListView(
      children: listWidget,
    );
  }
  @override
  void dispose(){
   inputController.dispose();
   channel.sink.close();
  }
}
