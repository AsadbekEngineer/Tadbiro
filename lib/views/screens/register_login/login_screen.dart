import 'package:exam/services/auth_http_services.dart';
import 'package:exam/views/screens/homescreen/homescreen.dart';
import 'package:exam/views/screens/register_login/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        String token = await FirebaseAuthService.loginUser(
          email: emailController.text,
          password: passwordController.text,
        );

        await TokenStorage.saveToken(token); // Save token

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return const Homescreen();
            },
          ),
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Xatolik"),
              content: Text(e.toString()),
            );
          },
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Container(
                      height: 200,
                      width: 400,
                      child: SvgPicture.asset('assets/images/tadbiro_logo.svg')
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Iltimos elektron pochta kiriting";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Parol',
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Iltimos parolingizni kiriting";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ), backgroundColor: Colors.orange,
                      ),
                      child: const Text(
                        'Kirish',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) {
                            return const RegisterScreen();
                          },
                        ),
                      );
                    },
                    child: const Text("Ro'yxatdan O'tish"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
