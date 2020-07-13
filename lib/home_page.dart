import 'package:blogapp/auth/authintication.dart';
import 'package:blogapp/model/posts.dart';
import 'package:blogapp/photoUpload.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  AuthImplementation auth;
  final VoidCallback onSignOut;

  HomePage({this.auth, this.onSignOut});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("Posts");
    reference.once().then((DataSnapshot snap) {
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      list.clear();

      for (var individualKey in KEYS) {
        Post post = Post(
            DATA[individualKey]['description'],
            DATA[individualKey]['date'],
            DATA[individualKey]['time'],
            DATA[individualKey]['image']);
        list.add(post);
      }
      setState(() {
        print('length : $list.Length');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: Container(
        child: list.length == 0
            ? Text("No Blog Post Available ")
            : ListView.builder(
                itemBuilder: (context, index) {
                  return postUi(
                    list[index].url,
                    list[index].description,
                    list[index].date,
                    list[index].time,
                  );
                },
                itemCount: list.length,
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Container(
          margin: EdgeInsets.only(left: 50, right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                onPressed: _logoutUser,
                icon: Icon(Icons.local_car_wash),
                iconSize: 40,
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return UploadPhotoPage();
                  }));
                },
                icon: Icon(Icons.add_a_photo),
                iconSize: 40,
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.local_car_wash),
                iconSize: 40,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logoutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Widget postUi(String image, String description, String date, String time) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.network(
              image,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
