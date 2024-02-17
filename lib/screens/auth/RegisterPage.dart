import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pds/screens/auth/LoginPage.dart';
import 'package:pds/screens/home.dart';
import 'package:pds/terms.dart';
import 'package:pds/user-auth/firebase-auth-services.dart';
import 'package:pds/widgets/alert.dart';

import '../../widgets/loading-indicator.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true; // to control the visibility of the password
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;

  // Create a firebase authentication instance
  final FirebaseAuthentication _firebaseAuth = FirebaseAuthentication();
  // Create a variable to store the error message
  String _errorMessage = '';


  // Define some regular expressions for validation
  final RegExp nameRegExp = RegExp(r'^[A-Za-z]+(\s[A-Za-z]+)*$');
  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp phoneRegExp = RegExp(r'^0\d{10}$');
  final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%\^&\*]).{8,}$');
  String _termsContent = Term().termsAndConditions;
  bool _termsAccepted = false; // Track terms acceptance
  void showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms and Conditions'),
        content: SingleChildScrollView(
          child: Text(_termsContent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => setState((){
              _termsAccepted = true;
              Navigator.pop(context);
            }),
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  // Define the sign up method
  Future<void> _signUp() async {

    // Get the email and password from the text fields
    String email = emailController.text;
    String password = passwordController.text;
    print('Email: $email');
    print('Password: $password');

    // Try to create a new user with email and password
    User? user = await _firebaseAuth.createUserWithEmailAndPassword(email, password);

    // If the user is not null, navigate to the home screen
    if (user != null) {
      print('User created successfully');
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      // Otherwise, display an error message
      setState(() {
        _errorMessage = 'Failed to create a new account';
        print(_errorMessage);
      });
    }
  }
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign up'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                      'assets/Sign up-rafiki.png'), // replace with your own image
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'User Name',
                    ),
                    // Add a validator for the name field
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      if (!nameRegExp.hasMatch(value.trim())) {
                        return 'Please enter a valid name';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Email',
                    ),
                    // Add a validator for the email field
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!emailRegExp.hasMatch(value.trim())) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    obscureText: obscureText,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
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
                    // Add a validator for the password field
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (!passwordRegExp.hasMatch(value.trim())) {
                        return 'Please enter a strong password';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() => _termsAccepted = value!);
                      },
                    ),
                    TextButton(
                      onPressed: () => showTermsDialog(),
                      child: const Text('Terms and Conditions'),
                    ),
                  ],
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Sign up'),
                    onPressed: () async {
                      print('Sign up button pressed');
                      if (_formKey.currentState!.validate()) {
                        print('Form is valid');
                        if (!_termsAccepted) {
                          showSnackBar(context, 'Please accept the terms and conditions');
                          // Show an error message indicating required terms acceptance
                          return;
                        }

                        try {

                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          final name = nameController.text.trim();

                          loadingIndicator(context);

                          // Create a new user account using Firebase Authentication
                          final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          print(name);
                          print(userCredential.user!);
                          await userCredential.user!.updateDisplayName(name);
                          print(userCredential.user!.displayName);

                          // Upon successful registration, navigate to the next screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                          );
                        } on FirebaseAuthException catch (e) {
                          // **Improved error handling:**
                          print(e.message); // Log the specific error message
                          showAlert(context, e.message.toString(), "Sign up Error"); // Show a more informative dialog
                        }
                      }
                    },

                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already have an account?',
                        style: TextStyle(color: Colors.grey)),
                    TextButton(
                      child: const Text(
                        'Login',
                      ),
                      onPressed: () {
                        // navigate to the login screen
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Login()));
                      },
                    )
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
