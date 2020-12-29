import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partner_side_e_commerce/screens/after_completion.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partner_side_e_commerce/widgets/imagepicker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddDetails extends StatefulWidget {
  final String phone;
  AddDetails(this.phone);

  @override
  _AddDetailsState createState() => _AddDetailsState();
}

class _AddDetailsState extends State<AddDetails>
    with SingleTickerProviderStateMixin {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File _image;
  double age = 0.0;
  var selectedYear;
  Animation ani;
  AnimationController anico;
  TextEditingController firstNameData = TextEditingController();

  TextEditingController lastNameData = TextEditingController();

  TextEditingController genderData = TextEditingController();

  TextEditingController areaOfServiceData = TextEditingController();

  //DateTime dob;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  Stream documentStream =
      FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
  @override
  void initState() {
    print(widget.phone);
    anico = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    ani = anico;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    anico.dispose();
  }

  // We are picking image here
  // Future<void> _pickImage(ImageSource source) async {
  //   File selected = await ImagePicker.pickImage(source: source);

  //   setState(() {
  //     _imageFile = selected;
  //   });
  // }

  // // Cropping Image using this method
  // Future<void> _cropImage() async {
  //   File cropped = await ImageCropper.cropImage(
  //     sourcePath: _imageFile.path,
  //   );
  //   /*
  //     ratioX:1.0,

  //   */
  // }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    debugPrint(image.path);
    setState(() {
      _image = image;
      debugPrint(image.path);
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      debugPrint(image.path);
      debugPrint(image.toString());
      uploadFile(image.path);
    });
  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('uploads/profile.png')
          .putFile(file);
    } catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  void _showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> fixUser(String numId) {
    print(numId);
    return ref
        .doc(numId)
        .set({
          'first_name': firstNameData.text, // John Doe
          'last_name': lastNameData.text, // Stokes and Sons
          'gender': genderData.text,
          //'age': dob, // 42,
          'area_of_service': areaOfServiceData.text,
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

  // Future<void> addNumber() {
  //   // Call the user's CollectionReference to add a new user
  //   return users
  //       .add({
  //         'full_name': fullName, // John Doe
  //         'company': company, // Stokes and Sons
  //         'age': age // 42
  //       })
  //       .then((value) => print("User Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  void _showPicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime(2020),
            firstDate: DateTime(1900),
            lastDate: DateTime.now())
        .then((DateTime dob) {
      setState(() {
        selectedYear = dob.year;
        calculateAge();
      });
    });
  }

  void calculateAge() {
    setState(() {
      age = (DateTime.now().year - selectedYear) * 1.0;
      ani = Tween<double>(begin: ani.value, end: age)
          .animate(CurvedAnimation(curve: Curves.decelerate, parent: anico));
    });
    ani.addListener(() {
      setState(() {});
    });
    anico.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Add Data to your profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ), //COnstrained Box
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder<dynamic>(
            stream: ref.snapshots(),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  GestureDetector(
                    onTap: () {
                      _showImagePicker(context);
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xffFDCF09),
                      child: _image != null
                          ? ClipOval(
                              // borderRadius: BorderRadius.circular(50),
                              child: Hero(
                                tag: 'profile',
                                child: Image.file(
                                  _image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),

                  // CircleAvatar(
                  //   backgroundColor: Colors.grey,
                  //   child: Stack(
                  //     fit: StackFit.expand,
                  //     children: [
                  //       Positioned(
                  //           //height: 10,
                  //           bottom: 40,
                  //           left: 30,
                  //           width: 60,
                  //           child: FlatButton(
                  //             child: Icon(Icons.camera),
                  //             onPressed: () {
                  //               ImageCapture();
                  //             },
                  //           ))
                  //     ],
                  //   ),
                  //   radius: 70,
                  // ),
                  // ImageCapture(),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildField(firstNameData, "First Name"),
                        SizedBox(
                          width: 10,
                        ),
                        _buildField(lastNameData, "Last Name"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildField(genderData, "Gender"),
                  SizedBox(
                    height: 20,
                  ),
                  _buildField(areaOfServiceData,
                      "Area you can provide your service to"),
                  SizedBox(
                    height: 20,
                  ),
                  OutlineButton(
                    child: Text(selectedYear != null
                        ? "$selectedYear"
                        : "Date of Birth"),
                    onPressed: () {
                      _showPicker();
                    },
                    borderSide: BorderSide(color: Colors.black, width: 3),
                    color: Colors.red,
                    hoverColor: Colors.amber,
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  AnimatedBuilder(
                      animation: ani,
                      builder: (context, child) {
                        return Text(
                          "Age ${ani.value.toStringAsFixed(0)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontStyle: FontStyle.italic),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton.icon(
                      icon: Icon(Icons.done),
                      label: Text("Submit"),
                      borderSide: BorderSide(color: Colors.black, width: 3),
                      color: Colors.red,
                      hoverColor: Colors.amber,
                      onPressed: () {
                        //addUser();
                        fixUser(widget.phone);
                        print(widget.phone);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AfterCompletion(),
                        ));
                      },
                    ),
                  ),
                ]),
              );
            },
          ),
        ),
      ),
    );
  }
}
