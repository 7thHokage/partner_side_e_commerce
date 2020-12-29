import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';

class PaymentRazor extends StatefulWidget {
  @override
  _PaymentRazorState createState() => _PaymentRazorState();
}

class _PaymentRazorState extends State<PaymentRazor> {
  Razorpay razorPay;
  TextEditingController textEdit = TextEditingController();

  @override
  void initState() {
    super.initState();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    razorPay.clear();
    super.dispose();
  }

  Future<void> openCheckOut() async {
    var options = {
      'key': "rzp_test_W7OH2Gi8itYdVw",
      "amount": '200', // await num.parse(textEdit.text) * 100,
      'name': "njvsjvns",
      'des': "Just give me your Money",
      'prefill': {
        "contact": "+919165422007",
        'email': 'prakul@7@gmail.com',
      },
      'external': {
        'wallets': {'paytm'}
      }
    };

    try {
      razorPay.open(options);
    } catch (e) {
      print(e.toString());
      debugPrint(
          "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
    }
  }

  void handlerPaymentSuccess() {
    debugPrint("Succesful");
    Toast.show("PayMent Success", context);
  }

  void handlerErrorFailure() {
    debugPrint("Fail");
  }

  void handlerExternalWallet() {
    debugPrint("External");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Razor Pay"),
      ),
      body: Column(
        children: [
          TextField(
            controller: textEdit,
            decoration: InputDecoration(hintText: " Pay"),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            onPressed: () async {
              await openCheckOut();
            },
            child: Text("Pay Now "),
          )
        ],
      ),
    );
  }
}
