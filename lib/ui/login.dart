import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

//Include route perhaps
  @override
  Widget build(BuildContext context) {
    return const Login(); //Call the login Statefulwidget
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginScreenState();
}

class LoginScreenState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(
                width: 16,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(
                height: 32,
              ),
              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        // Navigate to main form screen
                        Navigator.pushNamed(context, '/registration_form');
                      },
                      child: const Text("Login")))
            ],
          ),
        ),
      ),
    );
  }
}
