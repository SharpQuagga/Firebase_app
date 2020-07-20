import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File _image;
  final picker = ImagePicker();
  var time = DateTime.now();
  String _downloadUrl;
  // final _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _caption = new TextEditingController();


  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future _storageUpload(File file) async {
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(time.toIso8601String());
    final StorageUploadTask task = storageRef.putFile(_image);
    var url = await (await task.onComplete).ref.getDownloadURL();
    return url.toString();
  }

  Future<void> _firebaseUpload(File file) async {
    if (file == null) {
      Toast.show("Error, please fill all the fields !", context);
    } else {
      _downloadUrl = await _storageUpload(file);
      if (_name.text != null && _caption.text!=null) {
        Firestore.instance.collection('Images').add({
          'ImageUrl': _downloadUrl,
          'Name': _name.text,
          'Caption':_caption.text,
        }).catchError((e) {
          print(e);
        });
        Toast.show("Uploaded", context);
      } else {
        Toast.show("Fill all details", context);
      }
    }
  }

  _inputDecoration(label) => InputDecoration(
      labelText: label,
      fillColor: Colors.white,
      border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(18.0),
          borderSide: new BorderSide()));

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: Form(
          // key: _formKey,
          child: ListView(
            children: [
              RaisedButton(
                onPressed: () {getImageFromCamera();},
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
                textColor: Colors.white,
                elevation: 10,
                 child: Text('Get Image from camera'),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {getImageFromGallery();},
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue)),
                textColor: Colors.white,
                elevation: 10,
                 child: Text('Get Image from Gallery'),
              ),
             
              SizedBox(
                height: 10,
              ),
              TextFormField(
                // key: new Key('Name'),
                decoration: _inputDecoration("Name"),
                controller: _name,
                style: TextStyle(),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                // key: new Key('Caption'),
                controller: _caption,
                decoration: _inputDecoration("Caption"),
                style: TextStyle(),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: _image != null ? Image.file(_image) : null,
            ),
            SizedBox(
                height: 10,
              ),
            RaisedButton(
              onPressed: () {
                _firebaseUpload(_image);
              },
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.blue)),
              textColor: Colors.white,
              elevation: 10,
              child: Text("Upload"),
            )
            ],
          ),
        ),
      );
  }
}
