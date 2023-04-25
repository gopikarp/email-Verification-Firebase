import 'package:emailbyme/utils/constants/firebase_constants.dart';
import 'package:emailbyme/utils/constants/screen/email_verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailcontro = TextEditingController();
  final passcontro = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 150),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                right: 182,
                bottom: 49,
              ),
              child: Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 49,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: emailcontro,
              decoration: const InputDecoration(
                label: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: passcontro,
              decoration: const InputDecoration(
                label: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 29,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await signUp(
                    userEmail: emailcontro.text,
                    password: passcontro.text,
                    context: context);
                if (auth_.currentUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => EmailVerificationScreen(),
                    ),
                  );
                }
                setState(() {
                  _isLoading = false;
                });
              },
              child: const Text(
                'sign up',
                style: TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static Future<User?> signUp(
      {required String userEmail,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
