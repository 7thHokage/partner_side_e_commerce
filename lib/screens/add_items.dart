import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partner_side_e_commerce/screens/homepage.dart';
import 'package:path/path.dart' as Path;

class AddItems extends StatefulWidget {
  @override
  _AddItemsState createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  bool uploading = false;
  double val = 0.0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  String v;
  List<File> _image = [];
  final picker = ImagePicker();
  TextEditingController nameOfProduct = TextEditingController();

  TextEditingController priceOfProduct = TextEditingController();

  TextEditingController descriptionOfProduct = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference refer = FirebaseFirestore.instance.collection('items');

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      debugPrint(response.file.path);
    }
  }

  Future<void> uploadFile() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('items/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          v = value;
          //imgRef.add({'url': value});
          refer
              .doc(nameOfProduct.text)
              .collection("Images")
              .add({'url3': value});
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance
        .collection('items')
        .doc()
        .collection('urlOfImages');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fixUser() {
    return refer
        .doc(nameOfProduct.text)
        .set({
          'name_of_product': nameOfProduct.text, // John Doe
          'price_of_product': priceOfProduct.text, // Stokes and Sons
          'description': descriptionOfProduct.text,
          'url': v,
          //'age': dob, // 42,
          //'area_of_service': areaOfServiceData.text,
          //'profile_image': _image,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to aaaaaaaadd user: $error"));
  }

  _buildField(TextEditingController controller, String labelText) {
    return Flexible(
      fit: FlexFit.loose,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.amber),
        ),
        child: Flexible(
          fit: FlexFit.loose,
          child: TextField(
            controller: controller,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              alignLabelWithHint: true,
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.amber),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Add Items"),
        actions: [
          FlatButton(
            onPressed: () {
              // fixUser();
              setState(() {
                uploading = true;
              });
              uploadFile().whenComplete(
                () => fixUser().whenComplete(
                  () => Navigator.of(context).pop(),
                ),
              );
            },
            child: Text("Add photos"),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              _buildField(nameOfProduct, "Name"),
              SizedBox(
                height: 20,
              ),
              _buildField(priceOfProduct, "Price"),
              SizedBox(
                height: 20,
              ),
              _buildField(descriptionOfProduct, "Description"),
              SizedBox(
                height: 20,
              ),
              Text(
                "Add Photos of your Products",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 300,
                child: Card(
                  color: Colors.amber,
                  child: GridView.builder(
                    itemCount: _image.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? Center(
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  chooseImage();
                                },
                              ),
                            )
                          : Container(
                              // child: Text("jjjjj"),
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(
                                      _image[index - 1],
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     chooseImage();
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
