import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart'; //Image plugin
import 'dart:async';
import 'dart:io';

class PlantsPage extends StatefulWidget {
  _PlantsPageState createState() => _PlantsPageState();
}

class _PlantsPageState extends State<PlantsPage> {
  final _formKey = GlobalKey<FormState>();
  File plantImage;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  final nameController = new TextEditingController();
  final lightRequirementController = new TextEditingController();
  final speciesController = new TextEditingController();

  Widget displaySelectedFile(File file) {
    return new SizedBox(
      height: 200.0,
      width: 300.0,
      child: file == null
          ? new Text('No image selected!!', textAlign: TextAlign.center)
          : new Image.file(file),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var temp = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        plantImage = temp;
      });
    }

    // Future enableUpload(BuildContext context) async {
    //   String filename = basename(plantImage.path);
    //   StorageReference firebaseStorageRef =
    //       FirebaseStorage.instance.ref().child(filename);
    //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(plantImage);
    //   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    //   setState(() {
    //     print("plant img uploaded");
    //   });
    // }

    Future saveToDatabase(BuildContext context) async {
      final currentUser = await _firebaseAuth.currentUser();
      if (_formKey.currentState.validate()) {
        String filename = basename(plantImage.path);
        StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(filename);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(plantImage);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        setState(() {
          print("plant img uploaded");
        });
        await databaseReference.child("plants").set({
          'uid': currentUser.uid,
          'plantName': nameController.text,
          'speciesName': speciesController.text,
          'lightRequirement': lightRequirementController.text,
          'imageUrl': taskSnapshot.ref.getDownloadURL().toString()
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: new ListView(
        shrinkWrap: true,
        //Center(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          displaySelectedFile(plantImage),
          new RaisedButton(
            child: Text("Add Plant Image"),
            color: Colors.lightGreen,
            onPressed: getImage,
          ),
          new RaisedButton(
            color: Colors.lightGreen,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(labelText: 'Name:'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a name for this Plant';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: speciesController,
                                decoration:
                                    InputDecoration(labelText: 'Species'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a name for this Plant';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextFormField(
                                  controller: lightRequirementController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a name for this Plant';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Light Requirement')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(
                                child: Text("Submit"),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                  }
                                  if (plantImage == null) {
                                    print('Select an Image');
                                  } else {
                                    // enableUpload(context);
                                    saveToDatabase(context);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Text("Add a Plant"),
          ),
        ],
      ),
        // This is code that would build a bottom nav-bar. I copied and pasted
        // from this link:
        // https://medium.com/flutterpub/flutter-6-bottom-navigation-38b202d9ca23

        bottomNavigationBar:BottomNavigationBar(
          // .shifting means that
          type: BottomNavigationBarType.shifting ,
          backgroundColor: Color.fromARGB(255, 38, 196, 133),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit,color: Color.fromARGB(255, 38, 196, 133)),
                title: new Text('')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit,color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text('')
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_alarm,color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text('')
            )
          ],
        )
    );
  }
}