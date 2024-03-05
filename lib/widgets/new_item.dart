import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rentnew/model/product.dart';
import 'package:get_it/get_it.dart';
import 'package:rentnew/service/AuthenticationService.dart';

class NewItem extends StatefulWidget {
  final Function addItem;

  const NewItem({super.key, required this.addItem});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _positionController = TextEditingController();
  final firebaseSingletonInstance = GetIt.I.get<AuthenticationService>();

  void _submitData() {
    final inputName = _nameController.text;
    final inputDesc = _descriptionController.text;
    final inputPos = _positionController.text;

    if (inputDesc.isEmpty || inputName.isEmpty || inputPos.isEmpty) return;

    final newItem = Product(Random().nextInt(15), inputName, inputDesc,
        inputPos, firebaseSingletonInstance.getCurrentUserEmail());

    widget.addItem(
        newItem); //prethodno definiravme propery f-ja: final Function addTodo;

    Navigator.of(context)
        .pop(); //imame stack na widgets, za da se vratime nazad
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      //style na containerot, stava padding na site strani
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Name:"),
            onSubmitted: (_) => _submitData,
          ),
          TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description:"),
              onSubmitted: (_) => _submitData),
          TextField(
              controller: _positionController,
              decoration: InputDecoration(labelText: "Position:"),
              onSubmitted: (_) => _submitData),
          ElevatedButton(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            onPressed: _submitData,
            child: Text("Submit!"),
            style: ElevatedButton.styleFrom(
                primary: Colors.purple[100],
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
