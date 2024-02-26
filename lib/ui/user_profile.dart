import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProfile extends StatelessWidget {

  final File? selectedImage;
  final String username;

  UserProfile({Key? key, required this.selectedImage, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      width: 200,
      height: 200,
      margin: const EdgeInsets.only(right: 180),
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
            const Text("No Image so far"),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              if (username.length > 19)
                Text("${username.substring(0, 19)}...")
              else
                Text(username),
              // SizedBox(width: 1),

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


  Future _pickImageFromGallery() async {
    final returnedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    // setState(() {
    //   selectedImage = File(returnedImage!.path);
    // });

    // Create a storage reference from our app
    // final storageRef = FirebaseStorage.instance.ref();


// Create a reference to 'images/mountains.jpg'
//     final mountainImagesRef = storageRef.child("images/mountains.jpg");


  }
}
