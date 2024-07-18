import 'package:exam/services/auth_http_services.dart';
import 'package:exam/views/screens/homescreen/homescreen.dart';
import 'package:exam/views/screens/register_login/register.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final fireAuthService = FirebaseAuthService();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void submit() async {
    if (formKey.currentState!.validate()) {
      //? login

      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuthService.loginUser(
          email: emailController.text,
          password: passwordController.text,
        );

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
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.flutter_dash_sharp,
                size: 120,
                color: Colors.blue,
              ),
              const Text(
                "Tizimga Kirish",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Elektron pochta",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos elektron pochta kiriting";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Parol",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Iltimos parolingizni kiriting";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton(
                  onPressed: submit,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text("KIRISH"),
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
    );
  }
}