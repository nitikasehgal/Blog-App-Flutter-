import 'package:blog_app/firebasefunction.dart';
import 'package:blog_app/posts.dart';
import 'package:blog_app/uploads.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> Post = [];
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('blogs');
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    reference.once().then((snap) async {
      var data = snap.snapshot.value as Map<dynamic, dynamic>;
      var keys = data.keys;
      Post.clear();
      for (var individualKey in keys) {
        Posts post = Posts(
            description: data[individualKey]['description'],
            imageUrl: data[individualKey]['image'],
            date: data[individualKey]['date'],
            time: data[individualKey]['time']);

        Post.add(post);
      }
      setState(() {
        print(Post.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blogs")),
      body: Container(
        child: Post.length == 0
            ? Center(
                child: Text(
                "No blogs available..upload one",
                style: TextStyle(fontSize: 25),
              ))
            : ListView.builder(
                itemBuilder: (context, index) {
                  return postUi(Post[index].imageUrl, Post[index].description,
                      Post[index].date, Post[index].time);
                },
                itemCount: Post.length,
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.purpleAccent,
        child: Container(
          margin: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              IconButton(
                  onPressed: () {
                    signout();
                  },
                  icon: Icon(
                    Icons.logout,
                    size: 40,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Upload();
                    }));
                  },
                  icon: Icon(
                    Icons.upload,
                    size: 40,
                    color: Colors.white,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget postUi(String image, String description, date, time) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                )
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
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
