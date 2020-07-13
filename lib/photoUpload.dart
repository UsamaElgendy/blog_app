import 'dart:async';
import 'dart:io';

import 'package:blogapp/home_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File _image;
  final picker = ImagePicker();
  String url;

  String _myValue;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload image'),
        centerTitle: true,
      ),
      body: Center(
          child:
              _image == null ? Text('Select an image') : enableUploadImage()),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUploadImage() {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(
              _image,
              height: 310.0,
              width: 660,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  return value.isEmpty ? 'Description is require ' : null;
                },
                onSaved: (value) {
                  _myValue = value;
                }),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              elevation: 10.0,
              child: Text('Add new Post'),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: uploadStatusImage,
            ),
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference storageReference =
          FirebaseStorage().ref().child("post image");
      var timeKey = DateTime.now();

      final StorageUploadTask uploadTask =
          storageReference.child(timeKey.toString() + ".jpg").putFile(_image);

      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = imageUrl.toString();
      print(url);

      final StreamSubscription<StorageTaskEvent> streamSubscription =
          uploadTask.events.listen((event) {
        print('EVENT ${event.type}');
      });

      await uploadTask.onComplete;
      streamSubscription.cancel();

      saveToDataBase(url);
      goToHomePage();
    }
  }

  void saveToDataBase(url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d ,yyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      'image': url,
      'description': _myValue,
      'date': date,
      'time': time,
    };
    ref.child('Posts').push().set(data);
  }

  void goToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ),
    );
  }
}
