import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  File _image;
  List _output;
  final picker = ImagePicker();
  final dbR = FirebaseDatabase.instance.reference();
  bool on = false;
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {

      });
    });
  }

  classifyingImage(File image) async{
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5,
    );
    setState(() {
      _output = output;
      _isLoading = false;
    });
  }
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose(){
    super.dispose();
    Tflite.close();
    super.dispose();
  }
  pickImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
    _image = File(image.path);

    });
    classifyingImage(_image);
  }
  pickGalleryImage() async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);

    });
    classifyingImage(_image);
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
       Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(

        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Text("Image",
            style: TextStyle(
              color: Color(0xFFEEDA28),
              fontSize: 24,
            ),
          ),
          SizedBox(height: 10,),
          Text("Classification", style: TextStyle(
            color: Color(0xFFE99600),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          ),
          SizedBox(height: 40,),
          Center(
            child: _isLoading ? Container(
              width: 300,
              child: Column(
                children: <Widget>[
                  Image.asset('assets/banana1.jpg'),
                  SizedBox(height: 50,),

                ],
              )
            ):Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 250,
                    child: Image.file(_image),
                  ),
                  SizedBox(height: 20,),
              _output != null ? Text('${_output[0]['label']}', style: TextStyle(color: Colors.white, fontSize: 20),):Container(),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap:  pickGalleryImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width-190,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text("Select Photo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap:  pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width-190,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left:15.0, right:15.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text("Use Camera",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      dbR.child("Fruit").set({"Ripening":'${_output[0]['label']}'});
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width-190,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 15.0,  right: 15.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text("Send To Arduino",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

        ],
      ),
    ),

        ],
      )
    );
  }
}
