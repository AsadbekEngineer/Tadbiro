import 'package:exam/services/auth_http_services.dart';
import 'package:exam/views/screens/add_user_info/add_usre_info.dart';
import 'package:exam/views/screens/register_login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  bool isLoading = false;

  void submit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        String token = await FirebaseAuthService.registerUser(
          email: emailController.text,
          password: passwordController.text,
        );

        await TokenStorage.saveToken(token); // Save token
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return const UserInfoScreen();
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    controller: passwordConfirmController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Parol tasdiqlang',
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Iltimos parolingizni tasdiqlang";
                      }
                      if (passwordConfirmController.text != passwordController.text) {
                        return "Parollar bir xil emas";
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
                        "Ro'yxatdan O'tish",
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
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    child: const Text("Tizimga kirish"),
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
