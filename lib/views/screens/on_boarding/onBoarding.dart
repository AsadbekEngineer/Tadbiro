import 'package:exam/views/screens/register_login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return LoginScreen();
            }));
          },
          child: Center(
            child: Container(
              height: 200,
              width: 400,
              child: SvgPicture.asset('assets/images/tadbiro_logo.svg')
            ),
          ),
        ),
      ),
    );
  }
}
