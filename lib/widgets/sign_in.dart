import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../service/AuthenticationService.dart';

class SignIn extends StatefulWidget {
  final Function updateUserSignedIn;

  const SignIn({super.key, required this.updateUserSignedIn});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final firebaseSingletonInstance = GetIt.I.get<AuthenticationService>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitData() async {
    final inputEmail = _emailController.text;
    final inputPass = _passwordController.text;
    if (inputPass.isEmpty || inputEmail.isEmpty) return;

    await firebaseSingletonInstance.signIn(inputEmail, inputPass);

    print("Currently logged in!!!!!");
    widget.updateUserSignedIn();

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
            controller: _emailController,
            decoration: InputDecoration(labelText: "Email:"),
            onSubmitted: (_) => _submitData,
          ),
          TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password:"),
              onSubmitted: (_) => _submitData,
              obscureText: true),
          ElevatedButton(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            onPressed: _submitData,
            child: Text("Submit!"),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
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
