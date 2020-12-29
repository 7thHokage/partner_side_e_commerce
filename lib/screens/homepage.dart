import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partner_side_e_commerce/screens/payment.dart';
import 'package:partner_side_e_commerce/screens/payment_razor.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  String name;
  HomePage({this.name});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 500,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('items')
                // .doc('ttt')
                // .collection('Images')
                //.doc('1LKGxiuJvByzMQQLCqJO')
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      color: Colors.white,
                      child: GridView.builder(
                        itemCount: snapshot.data.documents.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          // setState(() {});
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 4.0,
                              color: Colors.amber,
                              shadowColor: Colors.green,
                              margin: EdgeInsets.all(5),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  FadeInImage.memoryNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                    image: snapshot.data.documents[index]
                                        .get('url'),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15))),
                                      //color: Colors.amber,
                                      child: Text(
                                        snapshot.data.documents[index]
                                            .get('price_of_product'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: Colors.amber,
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentThroughRazorPay(),
                                          ));
                                        },
                                        child: Text("Buy")),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
