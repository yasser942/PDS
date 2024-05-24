import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pds/screens/auth/LoginPage.dart';
import 'package:pds/widgets/alert.dart';

import '../../widgets/loading-indicator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextForm Controller
  TextEditingController emailController = TextEditingController();

  // Form Validation
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      try {
        final email = emailController.text.trim();
        loadingIndicator(context);
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Navigator.pop(context);
        // Show a circular progress indicator
        showAlert(context, 'Password reset email sent!', 'Success');
      } on FirebaseAuthException catch (e) {
        showAlert(context, e.message.toString(), 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                    'assets/Forgot password-amico.png'), // replace with your own image
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Forgot Password',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  style: const TextStyle(color: Colors.grey),
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    // Check if the input is empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Check if the input matches a valid email format using a regular expression
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => emailController.text = value!.trim(),
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: _validateAndSubmit,
                  child: const Text('Submit'),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  child: const Text('Back to Sign In'),
                  onPressed: () {
                    // navigate to the sign in screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Login())); // replace with your own route
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
