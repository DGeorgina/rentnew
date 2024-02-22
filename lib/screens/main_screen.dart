import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/product.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import '../service/AuthenticationService.dart';
import '../widgets/sign_in.dart';
import 'dart:io';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Product> _products = [];
  late File _selectedImage = File('');
  final firebaseSingletonInstance = GetIt.I.get<AuthenticationService>();
  bool userSignedIn = false;

  Future _pickImageFromCamera() async {
    final returnedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // setProductToDatabase(Product(1, "Microwave", "1 year old","ul. Ruger Boskovik 16 1000, Rugjer Boshkovikj 16, Skopje 1000"));
    getProductsFromDatabase();
    userSignedIn = (firebaseSingletonInstance.currentUser() != null);
  }

  void getProductsFromDatabase() async {
    final ref = FirebaseDatabase.instance.ref();

    try {
      final snapshot = await ref.child('products').get();
      if (snapshot.exists) {
        for (final child in snapshot.children) {
          Map<dynamic, dynamic> values = child.value as Map<dynamic, dynamic>;

          Product prod = Product(values["id"], values["name"],
              values["description"], values["location"]);

          setState(() {
            _products.add(prod);
          });
        }
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void setProductToDatabase(Product product) {
    DatabaseReference postListRef = FirebaseDatabase.instance.ref("products");
    DatabaseReference newPostRef = postListRef.push();

    newPostRef.set({
      "id": product.id,
      "name": product.name,
      "description": product.description,
      "location": product.position
    });
  }

  void _updateSignIn() {
    print("the user is signed in-----");
    print(firebaseSingletonInstance.currentUser() != null);
    print("donne");
    setState(() {
      userSignedIn = (firebaseSingletonInstance.currentUser() != null);
    });
  }

  _signIn() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: SignIn(
              //widgetot za signIn so se naoga vo folderot /widgets
              updateUserSignedIn: _updateSignIn,
            ),
          );
        });
  }

  _signOut() async {
    await firebaseSingletonInstance.signOut();

    _updateSignIn();
    print("Signed out!!!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userSignedIn ? 'logged in' : 'logged out'),
        backgroundColor: Theme.of(context).colorScheme.outlineVariant,
        actions: [
          IconButton(
              onPressed: () => (userSignedIn) ? _signOut() : _signIn(),
              icon: (userSignedIn)
                  ? const Icon(
                      Icons.arrow_back,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.green,
                    )),
        ],
      ),
      body: GridView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                _products[index].name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent),
              ),
              subtitle: Text(
                _products[index].description,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_rounded),
                onPressed: () {
                  setState(() {
                    _products.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items in each row
          mainAxisSpacing: 8.0, // spacing between rows
          crossAxisSpacing: 8.0, // spacing between columns
        ),
      ),
    );
  }
}
