import 'package:firebase_test/firebase/firebase_auth_controller.dart';
import 'package:firebase_test/models/firebaseResponse.dart';
import 'package:flutter/material.dart';

import '../../../Utils/Helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {
  late TextEditingController _emailEditingController;
  late TextEditingController _passwordEditingController;

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(20),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Text(
            'Welcome back...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Login to start using app',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 18,
              height: 1.5,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _emailEditingController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue.shade300,
                    width: 0.8,
                  ),
                )),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordEditingController,
            keyboardType: TextInputType.text,
            obscureText: _obscureText,
            textInputAction: TextInputAction.go,
            onSubmitted: (String value) async {
              await _performLogin();
            },
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blue.shade300,
                  width: 0.8,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ForgetPasswordScreen');
                },
                child: const Text(
                  'Forget password?',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          ElevatedButton(
            onPressed: () async => await _performLogin(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Login'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account',
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/RegisterScreen');
                  },
                  child: const Text(
                    'Create now!',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _performLogin() async {
    if (_checkData()) {
      await _login();
    }
  }

  bool _checkData() {
    if (_emailEditingController.text.isNotEmpty &&
        _passwordEditingController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, massage: 'Enter required data!', erorr: true);
    return false;
  }

  Future<void> _login() async {
    FirebaseResponse firebaseResponse = await FirebaseAuthController().singIn(
        email: _emailEditingController.text,
        password: _passwordEditingController.text);

    showSnackBar(context,
        massage: firebaseResponse.massage, erorr: !firebaseResponse.status);
    if (firebaseResponse.status) {
      Navigator.pushReplacementNamed(context, '/MainScreen');
    }
  }
}
