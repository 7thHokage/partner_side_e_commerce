//import 'dart:html';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:partner_side_e_commerce/screens/payment_razor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:partner_side_e_commerce/screens/add_items.dart';
import 'package:partner_side_e_commerce/widgets/imagepicker.dart';
//import 'package:firebase/firebase.dart';

class CustomDrawer extends StatefulWidget {
  final Function closeDrawer;

  const CustomDrawer({Key key, this.closeDrawer}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String downloadURL;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final ref =
      FirebaseStorage.instance.ref().child('uploads').child('profile.png');
  //var url = await ref.getDownloadURL();
  //File downloadToFile;
  File image;
  @override
  // void initState() async {
  //   super.initState();
  //   var url = await ref.getDownloadURL();
  //   debugPrint(url);
  //   // downloadFile();
  //   // debugPrint(downloadToFile.path);
  //   // downloadURLExample();
  // }

  Future<void> downloadURLExample() async {
    downloadURL = await ref.getDownloadURL();
    debugPrint(downloadURL);

    // Within your widgets:
    // Image.network(downloadURL);
  }

  // firebase_storage.Reference ref =
  //     firebase_storage.FirebaseStorage.instance.ref('uploads/profile.png');

  // Future<void> downloadFile() async {
  //   // Directory appDocDir = await getApplicationDocumentsDirectory();
  //   // File downloadToFile = File('${appDocDir.path}/profile.png');

  //   try {
  //     await firebase_storage.FirebaseStorage.instance
  //         .ref('uploads/profile.png')
  //         .writeToFile(downloadToFile);
  //     debugPrint(downloadToFile.path);
  //   } catch (e) {
  //     // e.g, e.code == 'canceled'
  //   }
  // }

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadImage(context, image).then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    setState(() {});
    return m;
  }

  @override
  Widget build(BuildContext context) {
    downloadURLExample();
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.white,
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 200,
              color: Colors.white, //grey.withAlpha(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: _getImage(context, downloadURL),
                    builder: (context, snapshot) {
                      return CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black,
                        child: ClipOval(
                          // clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: snapshot.data,
                        ),
                      );

                      // // if (snapshot.connectionState == ConnectionState.waiting)
                      // //   return CircleAvatar(child: CircularProgressIndicator());

                      // return Container();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("RetroPortal Studio")
                ],
              )),
          ListTile(
            onTap: () {
              debugPrint("Tapped Profile");
            },
            tileColor: Colors.white,
            leading: Icon(Icons.person),
            title: Text(
              "Your Profile",
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              debugPrint("Tapped settings");
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddItems(),
              ));
            },
            leading: Icon(Icons.settings),
            title: Text("Add Items"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaymentRazor(),
              ));
              debugPrint("Tapped Payments");
            },
            leading: Icon(Icons.payment),
            title: Text("Payments"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImageCapture(),
              ));
              debugPrint("Tapped Notifications");
            },
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              debugPrint("Tapped Log Out");
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance
        .ref()
        .child('uploads')
        .child('profile.png')
        .getDownloadURL();
  }
}
