// import 'package:flutter/material.dart';
// import 'package:material_dialogs/material_dialogs.dart';
// import 'package:material_dialogs/widgets/buttons/icon_button.dart';
// import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

// class CustomBottomDialog {
//   /// Displays a customizable bottom dialog using material_dialogs
//   static void show({
//     required BuildContext context,
//     required String title,
//     required String message,
//     required VoidCallback onConfirm,
//     VoidCallback? onCancel,
//   }) {
//     Dialogs.bottomMaterialDialog(
//       msg:
//           'Brooklyn Business School was established in 2009 as an Academy of excellence for the design, delivery and dissemination of training and professional development programs in a variety of domains and fields aiming at the formulation of world class managers, experts, practitioners and trainers.',
//       title: 'About Brooklyn Business School',
//       color: Colors.white,

//       context: context,
//       actions: [
//         IconsButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           text: 'Close',
//           iconData: Icons.done,
//           color: Theme.of(context).scaffoldBackgroundColor,
//           textStyle: TextStyle(color: Colors.white),
//           iconColor: Colors.white,
//         ),
//       ],
//     );
//   }
// }
