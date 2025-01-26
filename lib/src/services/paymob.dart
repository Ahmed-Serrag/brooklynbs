import 'package:flutter/services.dart';

const methodChannel = MethodChannel('paymob_sdk_flutter');

// Method to call native PaymobSDKs
Future<void> _payWithPaymob(
  String pk,
  String csk, {
  String? appName,
  Color? buttonBackgroundColor,
  Color? buttonTextColor,
}) async {
  try {
    final String result = await methodChannel.invokeMethod('payWithPaymob', {
      "publicKey": pk,
      "clientSecret": csk,
      "appName": appName,
      "buttonBackgroundColor": buttonBackgroundColor?.value,
      "buttonTextColor": buttonTextColor?.value,
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
