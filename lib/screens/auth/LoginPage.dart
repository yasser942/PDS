import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pds/screens/auth/RegisterPage.dart';
import 'package:pds/screens/auth/forgot-password.dart';
import 'package:pds/screens/home.dart';

import '../../widgets/alert.dart';
import '../../widgets/loading-indicator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true; // to control the visibility of the password

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          // Wrap the ListView with a Form widget
          child: Form(
            // Assign the form key to the Form widget
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                      'assets/Fingerprint-bro.png'), // replace with your own image
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),

                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  // Replace the TextField with a TextFormField
                  child: TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20), // add this line
                      ),
                      labelText: 'Email',
                    ),
                    // Provide a validator function for the TextFormField
                    validator: (value) {
                      // Check if the input is empty
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Check if the input matches a valid email format using a regular expression
                      if (! RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }
                      // Return null if the input is valid
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  // Replace the TextField with a TextFormField
                  child: TextFormField(
                    obscureText: obscureText,
                    controller: passwordController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20), // add this line
                      ),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),

                    ),
                    // Provide a validator function for the TextFormField
                    validator: (value) {
                      // Check if the input is empty
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }

                      // Return null if the input is valid
                      return null;
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //forgot password screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()),
                    );
                  },
                  child: const Text('Forgot Password'),
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final email = nameController.text.trim().toLowerCase();
                          final password = passwordController.text.trim();

                          // Show a circular progress indicator
                          loadingIndicator(context);

                          // Use Firebase Authentication to sign in the user
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                                (Route<dynamic> route) => false,
                          );

                        } on FirebaseAuthException catch (e) {
                          // Handle authentication errors
                          print(e.message);

                          // Dismiss the circular progress indicator
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }

                          // Show an alert to the user
                          showAlert(context, e.message.toString(), 'Login Error');
                        }
                      }
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Do not have account?',
                        style: TextStyle(color: Colors.grey)),
                    TextButton(
                      child: const Text(
                        'Sign up',
                      ),
                      onPressed: () {
                        //signup screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
