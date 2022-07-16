import 'package:firebase_test/firebase/firebase_auth_controller.dart';
import 'package:firebase_test/models/firebaseResponse.dart';
import 'package:flutter/material.dart';

import '../../../Utils/Helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  late TextEditingController _emailEditingController;

//  late TextEditingController _nameEditingController;
  late TextEditingController _passwordEditingController;
  String _gender = 'M';
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _emailEditingController = TextEditingController();
    //  _nameEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
    // _nameEditingController.dispose();
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
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'REGISTER',
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
            'Create new account...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Create account to start app',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 18,
              height: 1,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 20),
          //TextField(
          //  controller: _nameEditingController,
          //  keyboardType: TextInputType.name,
          //  decoration: InputDecoration(
          //    prefixIcon: const Icon(Icons.person),
          //    hintText: 'full name',
          //    border: OutlineInputBorder(
          //      borderRadius: BorderRadius.circular(10),
          //      borderSide: BorderSide(color: Colors.blue.shade300),
          //    ),
          //  ),
          //),
          //const SizedBox(height: 10),
          TextField(
            controller: _emailEditingController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail),
              hintText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue.shade300),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordEditingController,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.go,
            onSubmitted: (value) async {
              await _performRegister();
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              hintText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue.shade300),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Male'),
                  value: 'M',
                  groupValue: _gender,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _gender = value;
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Female'),
                  value: 'F',
                  groupValue: _gender,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _gender = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => await _performRegister(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  Future<void> _performRegister() async {
    if (_checkData()) {
      await _register();
    }
  }

  bool _checkData() {
    if (_emailEditingController.text.isNotEmpty &&
            _passwordEditingController.text.isNotEmpty
        // && _nameEditingController.text.isNotEmpty
        ) {
      return true;
    }
    showSnackBar(context, massage: 'Enter required data!', erorr: true);
    return false;
  }

  Future<void> _register() async {
    FirebaseResponse firebaseResponse = await FirebaseAuthController()
        .createAccount(
            email: _emailEditingController.text,
            password: _passwordEditingController.text);
    showSnackBar(context,
        massage: firebaseResponse.massage, erorr: !firebaseResponse.status);
    if (firebaseResponse.status) {
      Navigator.pop(context);
    }
  }
}
