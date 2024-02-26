import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentnew/model/product.dart';
import 'package:get_it/get_it.dart';
import '../service/AuthenticationService.dart';
import '../widgets/sign_in.dart';
import 'package:rentnew/ui/user_profile.dart';
import 'package:rentnew/ui/item.dart';
import 'package:rentnew/service/LocationService.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Product> _products = [];
  double distanceToCurrentLocation = -1;
  final firebaseSingletonInstance = GetIt.I.get<AuthenticationService>();
  bool userSignedIn = false;
  File? _selectedImage;
  LocationService? locationService;

  @override
  void initState() {
    super.initState();
    locationService = LocationService(setDistance: setDistance);
    // setProductToDatabase(Product(3, "Bike", "5 year old","ul. Partizanski Odredi"));
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
      body: Column(children: [
        if (distanceToCurrentLocation == -1)
          TextButton(
              onPressed: () =>
                  locationService?.calculateDistance(42.0046584, 21.409285),
              child: const Text("Show distance"))
        else
          Text('The distance is: $distanceToCurrentLocation km'),
        TextButton(
            onPressed: () {
              _pickImageFromGallery();
            },
            child: Text("pick img")),
        if (userSignedIn)
          UserProfile(
              selectedImage: _selectedImage,
              username: firebaseSingletonInstance.getCurrentUserEmail()),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return Item(
                product: _products.elementAt(index),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // number of items in each row
              mainAxisSpacing: 8.0, // spacing between rows
              crossAxisSpacing: 8.0, // spacing between columns
            ),
          ),
        ),
      ]),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
  }

  void setDistance(double distance) {
    setState(() {
      distanceToCurrentLocation = distance;
    });
  }
}
