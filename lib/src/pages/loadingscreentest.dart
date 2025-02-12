import 'package:flutter/material.dart';
import 'package:brooklynbs/src/widgets/loading_screen.dart';

class LoadingTestPage extends StatelessWidget {
  const LoadingTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading Screen Test"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: LoadingWidget( ),
      ),
    );
  }
}
