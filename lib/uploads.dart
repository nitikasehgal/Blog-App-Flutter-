import 'dart:io';

import 'package:blog_app/home_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String description = '';
  XFile? sampleImage;
  String? url;
  final _key = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  getImage() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = image;
    });
  }

  validateandsave() {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      return true;
    }
    return false;
  }

  uploadstatusimage() async {
    if (validateandsave()) {
      final Reference reference =
          FirebaseStorage.instance.ref().child('images');
      var timekey = DateTime.now();
      final Task uploadTask = reference
          .child(timekey.toString() + ".jpg")
          .putFile(File(sampleImage!.path));
      var Imageurl = await (await uploadTask).ref.getDownloadURL();
      url = Imageurl.toString();
      print(url);
      gotoHomePage();
      saveTodatabase(url);
    }
  }

  gotoHomePage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  saveTodatabase(url) {
    var dbtimekey = DateTime.now();
    var formatedate = DateFormat('MMM d,yyyy');
    var formattime = DateFormat('EEEE, hh:mm aaa');
    String date = formatedate.format(dbtimekey);
    String time = formattime.format(dbtimekey);

    DatabaseReference dbreference = FirebaseDatabase.instance.ref();
    var data = {
      'image': url,
      'description': description,
      'date': date,
      'time': time
    };
    dbreference.child("blogs").push().set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Blog"),
        centerTitle: true,
      ),
      body: new Center(
        child: sampleImage == null ? Text("Select an image") : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getImage();
        },
        tooltip: "Add Image",
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return SingleChildScrollView(
      child: Container(
        child: Form(
            key: _key,
            child: Column(
              children: [
                Image.file(
                  File(sampleImage!.path),
                  height: 310,
                  width: 660,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    key: ValueKey('description'),
                    decoration: InputDecoration(
                      labelText: "Description",
                    ),
                    onSaved: (newValue) {
                      setState(() {
                        description = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return " Blog Description can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    uploadstatusimage();
                  },
                  child: Text(
                    "Add new blog",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
