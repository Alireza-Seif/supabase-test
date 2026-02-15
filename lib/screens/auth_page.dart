import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/screens/note_page.dart';

final supabase = Supabase.instance.client;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = false;

  Future<void> _authenticate() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      if (isLogin) {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        isLogin = true;
      } else {
        await supabase.auth.signUp(email: email, password: password);
        isLogin = true;
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NotesPage()),
        );
      }
    } catch (ex) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$ex")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(16.0),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text('Supabase App', style: TextStyle(fontSize: 36)),

            MyTextField(
              myTextFieldController: emailController,
              myTextFieldText: 'Email',
            ),
            MyTextField(
              myTextFieldController: passwordController,
              myTextFieldText: 'Password',
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _authenticate();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text(isLogin ? 'Login' : 'SignUp'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.myTextFieldController,
    required this.myTextFieldText,
  });

  final TextEditingController myTextFieldController;
  final String myTextFieldText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: myTextFieldController,
      decoration: InputDecoration(
        hintText: myTextFieldText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
