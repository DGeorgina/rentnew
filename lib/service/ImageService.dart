import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  Future<String> getImageDownloadUrl(String imagePath)  async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageUrl = await storageRef.child(imagePath).getDownloadURL();

    return imageUrl;
  }

  Future<String> uploadImageToFirebase(File image, String imagePath) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child(imagePath);

      UploadTask uploadTask = storageReference.putFile(image);

      // Attach a listener to the UploadTask
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      }, onError: (Object e) {
        print('Error during upload task: $e');
        // Handle the error, for example, by returning a suitable error message
      });

      await uploadTask;

      String imageUrl = await storageReference.getDownloadURL();

      print('Image uploaded successfully. URL: $imageUrl');

      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase: $e');
      return 'Error during image upload';
    }
  }
}
