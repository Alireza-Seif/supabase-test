import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_test/screens/note_page.dart';
import 'package:supabase_test/widgets/my_button.dart';
import 'package:supabase_test/widgets/my_text_field.dart';

final supabase = Supabase.instance.client;

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;

  Future<void> _authenticate() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
      } else {
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
        );

        // If email confirmation is enabled, session can be null here.
        if (response.session == null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Account created. Check your email to confirm your account.',
              ),
            ),
          );
          return;
        }
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotesPage()),
        );
      }
    } catch (ex) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$ex')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text('Supabase App', style: TextStyle(fontSize: 36)),

            MyTextField(
              myTextFieldController: emailController,
              myTextFieldText: 'Email',
              isPassword: false,
            ),
            MyTextField(
              myTextFieldController: passwordController,
              myTextFieldText: 'Password',
              isPassword: true,
            ),
            MyButton(
              onTap: isLoading ? null : _authenticate,
              text: isLoading
                  ? 'Please wait...'
                  : (isLogin ? 'Login' : 'Create Account'),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
              child: Text(
                isLogin
                    ? "Don't have an account? Sign up"
                    : 'Already have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
