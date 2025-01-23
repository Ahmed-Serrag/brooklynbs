import 'package:flutter/services.dart';

 const methodChannel = MethodChannel('paymob_sdk_flutter');

  // Method to call native PaymobSDKs
  // ignore: unused_element
  Future<void> _payWithPaymob(
      String pk,
      String csk,
       ) async {

    try {
      final String result = await methodChannel.invokeMethod('payWithPaymob', {
        "publicKey": pk,
        "clientSecret": csk,
        
      });
      print('Native result: $result');
      switch (result) {
        case 'Successfull':
          print('Transaction Successfull');
          // Do something for accepted
          break;
        case 'Rejected':
          print('Transaction Rejected');
          // Do something for rejected
          break;
        case 'Pending':
          print('Transaction Pending');
          // Do something for pending
          break;
        default:
          print('Unknown response');
      // Handle unknown response
      }
    } on PlatformException catch (e) {
      print("Failed to call native SDK: '${e.message}'.");
    }
  }