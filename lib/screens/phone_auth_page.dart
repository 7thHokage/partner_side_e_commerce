import 'package:flutter/material.dart';
import 'package:partner_side_e_commerce/screens/add-details.dart';
import 'package:partner_side_e_commerce/screens/homepage.dart';
import 'package:partner_side_e_commerce/screens/after_completion.dart';
import 'otp.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _numcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Phone Auth"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      "Phone Authentication ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        hintText: "Phone Number ",
                        prefix: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            '+91',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.amber),
                          ),
                        ),
                      ),
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      controller: _numcontroller,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                print(_numcontroller.text);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      // AddDetails(_numcontroller.text),
                      OtpScreen(_numcontroller.text),
                  //AfterCompletion(),
                ));
              },
              child: Text("Send Otp"),
              color: Colors.amber,
            ),
          )
        ],
      ),
    );
  }
}
