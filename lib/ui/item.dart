import 'package:flutter/material.dart';
import 'package:rentnew/model/product.dart';
import 'package:get_it/get_it.dart';
import 'package:rentnew/service/AuthenticationService.dart';

class Item extends StatelessWidget {
  final Product product;
  final Function deleteProduct;
  final firebaseSingletonInstance = GetIt.I.get<AuthenticationService>();

  Item({Key? key, required this.product, required this.deleteProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          product.name,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent),
        ),
        subtitle: Text(
          product.description,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
        trailing: Visibility(
          visible: (firebaseSingletonInstance.currentUser() != null) &&
              (product.editPrivilege ==
                  firebaseSingletonInstance.getCurrentUserEmail()),
          child: IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () {
              deleteProduct(product.id);
            },
          ),
        ),
      ),
    );
  }
}
