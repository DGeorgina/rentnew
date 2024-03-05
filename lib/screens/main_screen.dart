import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rentnew/model/product.dart';
import 'package:get_it/get_it.dart';
import '../service/AuthenticationService.dart';
import '../widgets/sign_in.dart';
import 'package:rentnew/ui/user_profile.dart';
import 'package:rentnew/ui/item.dart';
import 'package:rentnew/service/LocationService.dart';
import 'package:rentnew/service/ImageService.dart';
import 'package:rentnew/widgets/new_item.dart';

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
  String _selectedImage = "";
  LocationService? locationService;

  @override
  void initState() {
    super.initState();
    _selectedImage = "";
    locationService = LocationService(setDistance: setDistance);
    // setProductToDatabase(Product(3, "Bike", "5 year old","ul. Partizanski Odredi"));
    getProductsFromDatabase();
    userSignedIn = (firebaseSingletonInstance.currentUser() != null);
    initializeProfilePicture();
  }

  initializeProfilePicture() {
    if (firebaseSingletonInstance.getCurrentUserEmail().isNotEmpty) {
      ImageService()
          .getImageDownloadUrl(
              "images/${firebaseSingletonInstance.getCurrentUserEmail()}.jpg")
          .then((value) => _selectedImage = value)
          .catchError((error) {
        print("errorrr");
      });
      print(_selectedImage);
    }
  }

  getProfileImage(String downloadUrl) {
    setState(() {
      _selectedImage = downloadUrl;
    });
  }

  void getProductsFromDatabase() async {
    final ref = FirebaseDatabase.instance.ref();

    try {
      final snapshot = await ref.child('products').get();
      if (snapshot.exists) {
        for (final child in snapshot.children) {
          Map<dynamic, dynamic> values = child.value as Map<dynamic, dynamic>;

          Product prod = Product(
              values["id"],
              values["name"],
              values["description"],
              values["location"],
              values["editPrivilege"]);

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
      "location": product.position,
      "editPrivilege": product.editPrivilege
    });
  }

  void _updateSignIn() {
    print("the user is signed in-----");
    bool val = firebaseSingletonInstance.currentUser() != null;
    print(val);
    print("donne");
    setState(() {
      userSignedIn = (firebaseSingletonInstance.currentUser() != null);
    });
    initializeProfilePicture();
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

          if (userSignedIn)
            IconButton(
                onPressed: () => _addNewItemFunction(),
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Colors.green,
                )),
          TextButton(
            onPressed: () => (userSignedIn) ? _signOut() : _signIn(),
            child: Text(userSignedIn ? 'Log out' : 'Log in'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
          ),
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
        if (userSignedIn)
          UserProfile(
            profileImage: _selectedImage,
            username: firebaseSingletonInstance.getCurrentUserEmail(),
            updateProfileImage: getProfileImage,
          ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              return Item(
                product: _products.elementAt(index),
                deleteProduct: deleteProductById
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

  void _addNewItemFunction() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewItem(
              //widgetot za dodavanje na nov item so se naoga vo folderot /widgets
              addItem: _addNewItemToListAndDatabase,
            ),
          );
        });
  }

  void _addNewItemToListAndDatabase(Product product) {
    setState(() {
      _products.add(product);
    });
    setProductToDatabase(product);
  }

  void setDistance(double distance) {
    setState(() {
      distanceToCurrentLocation = distance;
    });
  }

  void deleteItem(int productId) {}

  void deleteProductById(int productId) {
    setState(() {
      for (int i = 0; i < _products.length; i++) {
        if (_products[i].id == productId) {
          _products.remove(_products[i]);
          break;
        }
      }
    });

    DatabaseReference productsRef = FirebaseDatabase.instance.ref("products");

    productsRef
        .orderByChild("id")
        .equalTo(productId)
        .once()
        .then((DatabaseEvent event) {
      Map<dynamic, dynamic>? products = event.snapshot.value as Map?;

      if (products != null) {
        // Flag to ensure only the first matching product is deleted
        bool firstProductFound = false;

        // Iterate through the products that match the condition
        products.forEach((key, value) {
          if (!firstProductFound) {
            DatabaseReference productRef = productsRef.child(key);

            // Delete the product
            productRef.remove().then((_) {
              print("First product with name $productId deleted successfully");
            }).catchError((error) {
              print("Error deleting product: $error");
            });

            firstProductFound =
                true; // Set the flag to true after deleting the first matching product
          }
        });
      } else {
        print("Product with id $productId not found");
      }
    }).catchError((error) {
      print("Error querying products: $error");
    });
  }

// void deleteProductByName(String productName) {
//   DatabaseReference productsRef = FirebaseDatabase.instance.ref("products");
//
//   productsRef.orderByChild("name").equalTo(productName).once().then((DatabaseEvent event) {
//     Map<dynamic, dynamic>? products = event.snapshot.value as Map?;
//
//     if (products != null) {
//       // Flag to ensure only the first matching product is deleted
//       bool firstProductFound = false;
//
//       // Iterate through the products that match the condition
//       products.forEach((key, value) {
//         if (!firstProductFound) {
//           DatabaseReference productRef = productsRef.child(key);
//
//           // Delete the product
//           productRef.remove().then((_) {
//             print("First product with name '$productName' deleted successfully");
//           }).catchError((error) {
//             print("Error deleting product: $error");
//           });
//
//           firstProductFound = true; // Set the flag to true after deleting the first matching product
//         }
//       });
//     } else {
//       print("Product with name '$productName' not found");
//     }
//   }).catchError((error) {
//     print("Error querying products: $error");
//   });
// }
}
