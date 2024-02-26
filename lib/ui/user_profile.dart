import 'dart:io';

import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final File? selectedImage;

  UserProfile({Key? key, required this.selectedImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      width: 200,
      height: 200,
      margin: EdgeInsets.only(right: 180),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedImage != null)
            Container(
              width: 200, // Set the width you desire
              height: 140, // Set the height you desire
              child: Image.file(selectedImage!, fit: BoxFit.cover),
            )
          else
            Text("No Image so far"),
            SizedBox(height: 8,),
          Row(
            children: [
              Text("Name"),
              SizedBox(width: 8),
              Text("Surname"),
              SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // Add edit button functionality here
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
//
// import 'package:flutter/material.dart';
//
// class UserProfile extends StatefulWidget {
//   final File ? selectedImage;
//
//   const UserProfile({super.key, required this.selectedImage});
//
//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }
//
// class _UserProfileState extends State<UserProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Profile'),
//       ),
//       body: Container(
//         width: 200, // Specify the width
//         height: 200, // Specify the height
//         alignment: Alignment.bottomLeft, // Align the content to the bottom left
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             widget.selectedImage != null
//                 ? Image.file(widget.selectedImage!)
//                 : Text("No Image so far"),
//             SizedBox(height: 8),
//             Row(
//               children: [
//                 Text("Name"),
//                 SizedBox(width: 8),
//                 Text("Surname"),
//                 SizedBox(width: 8),
//                 IconButton(
//                   onPressed: () {
//                     // Add edit button functionality here
//                   },
//                   icon: const Icon(Icons.edit),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
