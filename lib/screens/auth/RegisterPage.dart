import 'package:flutter/material.dart';
import 'package:pds/screens/auth/LoginPage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool obscureText = true; // to control the visibility of the password
  final _formKey = GlobalKey<FormState>();


  // Define some regular expressions for validation
  final RegExp nameRegExp = RegExp(r'^[A-Za-z]+(\s[A-Za-z]+)*$');
  final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp phoneRegExp = RegExp(r'^0\d{10}$');
  final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%\^&\*]).{8,}$');

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
                      'assets/Fingerprint-cuate.png'), // replace with your own image
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
                      if (!nameRegExp.hasMatch(value)) {
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
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: phoneController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Phone Number',
                    ),
                    // Add a validator for the phone number field
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!phoneRegExp.hasMatch(value)) {
                        return 'Please enter a valid phone number';
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
                      if (!passwordRegExp.hasMatch(value)) {
                        return 'Please enter a strong password';
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: false, // you can change this value dynamically
                      onChanged: (value) {
                        // add some logic to handle the checkbox state
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        // show the terms and conditions
                      },
                      child: const Text('Terms and Conditions'),
                    ),
                  ],
                ),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Sign up'),
                    onPressed: () {
                      // validate the user input and navigate to the next screen
                      // Use the _formKey to access the form state
                      if (_formKey.currentState!.validate()) {
                        // The input is valid, proceed to the next screen
                        // You can also perform other actions, such as sending the data to a server or saving it in a database
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Login()));
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
