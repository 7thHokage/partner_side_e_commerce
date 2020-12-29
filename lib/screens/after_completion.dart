import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:partner_side_e_commerce/screens/homepage.dart';
import 'package:partner_side_e_commerce/widgets/custom_drawer.dart';

class AfterCompletion extends StatefulWidget {
  @override
  _AfterCompletionState createState() => _AfterCompletionState();
}

class _AfterCompletionState extends State<AfterCompletion> {
  FSBStatus drawerStatus;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0.0,
        title: Text(
          "Shop",
          style: TextStyle(color: Colors.white),
        ),
        // actions: [FlatButton(onPressed: (){}, child:Text("Add Items")  )],
      ),
      body: FoldableSidebarBuilder(
        screenContents: HomePage(),
        drawer: CustomDrawer(
          closeDrawer: () {
            setState(() {
              drawerStatus = FSBStatus.FSB_CLOSE;
            });
          },
        ),
        status: drawerStatus,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              drawerStatus = drawerStatus == FSBStatus.FSB_OPEN
                  ? FSBStatus.FSB_CLOSE
                  : FSBStatus.FSB_OPEN;
            });
          }),
    );
  }
}
