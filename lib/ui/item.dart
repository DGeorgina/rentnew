import 'package:flutter/material.dart';
import 'package:rentnew/model/product.dart';

class Item extends StatelessWidget {
  final Product product;

  // const Item(Product product, {super.key, required this.product});
  const Item({Key? key, required this.product}) : super(key: key);


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
        trailing: IconButton(
          icon: const Icon(Icons.delete_rounded),
          onPressed: () {
            // setState(() {
            //   _products.removeAt(index);
            // });
          },
        ),
      ),
    );
  }
}
