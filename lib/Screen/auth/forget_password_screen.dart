import 'package:firebase_test/firebase/firebase_auth_controller.dart';
import 'package:firebase_test/models/firebaseResponse.dart';
import 'package:flutter/material.dart';

import '../../../Utils/Helpers.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with Helpers {
  late TextEditingController _emailEditingController;

  @override
  void initState() {
    super.initState();
    _emailEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text(
          'FORGET PASSWORD',
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
            'Forget Password ?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Enter email to sent code',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 18,
              height: 1,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async => await _performForgetPassword(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  Future<void> _performForgetPassword() async {
    if (_checkData()) {
      await _forgetPassword();
    }
  }

  bool _checkData() {
    if (_emailEditingController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, massage: 'Enter required data!', erorr: true);
    return false;
  }

  Future<void> _forgetPassword() async {
    FirebaseResponse firebaseResponse = await FirebaseAuthController()
        .forgetPassword(email: _emailEditingController.text);
    showSnackBar(context,
        massage: firebaseResponse.massage, erorr: !firebaseResponse.status);
    if (firebaseResponse.status) {
      Navigator.pop(context);
    }
  }
}
