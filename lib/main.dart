import 'dart:io';
import 'package:eee591/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
//    theme: ThemeData.dark(),
    home: HomeScreen(),
  ));
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  bool _isLoading;
  File _image;
  List _output;
  bool connected;
  WebSocketChannel channel;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }
  channelconnect(){ //function to connect
    try{
      channel = IOWebSocketChannel.connect("ws://192.168.4.1"); //channel IP : Port
      channel.stream.listen((message) {
        print(message);
        setState(() {
          if(message == "connected") {
            connected = true; //message is "connected" from NodeMCU
          }
        });
      },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },);
    }catch (_){
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if(connected == true){
       cmd = ("{$_output}");
        channel.sink.add(cmd); //sending Command to ESP
    }else{
      channelconnect();
      print("Websocket is not connected.");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Classification"),
      ),
      body: _isLoading ? Container(
        child: CircularProgressIndicator(),
      ):Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Container():Image.file(_image),
            SizedBox(height: 16,),
            _output == null ? Text(""):Text("${_output[0]["label"]}"

            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
       onPressed: (){
         chooseImage();
       },
        child: Icon(Icons.image,
        ),
      ),
    );
  }

  chooseImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _isLoading = true;
      _image = image;
    });
    runModeOnImage(image);
  }
  runModeOnImage(File image) async{
  var output = await Tflite.runModelOnImage(
      path: image.path,
    numResults: 2,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5,
    );
    setState(() {
      _isLoading = false;
      _output=output;
    });
  }

  loadModel() async {
     await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }
}
