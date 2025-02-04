import 'package:brooklynbs/src/widgets/request.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';

class RequestFormPage extends StatelessWidget {
  final UserModel user;

  const RequestFormPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: currentTheme
          .secondaryHeaderColor, // ✅ Change to a clean white background
      appBar: AppBar(
        title: const Text("New Request"),
        backgroundColor: currentTheme.cardColor, // ✅ Better color contrast
        elevation: 0,
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20.0), // ✅ More padding for better spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10), // ✅ Adds some top margin
            Text(
              "Fill out your request below",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade900, // ✅ Matching theme
              ),
            ),
            const SizedBox(height: 20), // ✅ Spacing before form
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: currentTheme.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: currentTheme.dialogBackgroundColor,
                      blurRadius: 3,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: CombinedForm(user: user), // ✅ Embed the form
              ),
            ),
          ],
        ),
      ),
    );
  }
}
