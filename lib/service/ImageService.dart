import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageService {
  Future<String> getImageDownloadUrl(String imagePath)  async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageUrl = await storageRef.child(imagePath).getDownloadURL();

    return imageUrl;
  }

  Future<String> uploadImageToFirebase(File image, String imagePath) async {
    try {
      // String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child(imagePath);
      // FirebaseStorage.instance.ref().child('images/$imageName.jpg');

      UploadTask uploadTask = storageReference.putFile(image);

      // Attach a listener to the UploadTask
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      }, onError: (Object e) {
        print('Error during upload task: $e');
        // Handle the error, for example, by returning a suitable error message
      });

      // Wait for the upload task to complete
      await uploadTask;

      // Retrieve the download URL
      String imageUrl = await storageReference.getDownloadURL();

      print('Image uploaded successfully. URL: $imageUrl');

      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase: $e');
      // Return an empty string or a suitable error message
      return 'Error during image upload';
    }
  }
}
