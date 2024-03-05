import 'package:firebase_database/firebase_database.dart';
import 'package:rentnew/model/product.dart';

class DatabaseService {
  Future<List<Product>> getProductsFromDatabase() async {
    List<Product> products = [];
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

          products.add(prod);
        }
      } else {
        print('No data available.');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return products;
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

  void deleteProductByIdFromDatabase(int productId) {
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

  DatabaseService();
}
