import 'package:exam/services/auth_http_services.dart';
import 'package:exam/views/screens/myEvents/myEventsPage.dart';
import 'package:exam/views/screens/register_login/login_screen.dart';
import 'package:exam/views/widgets/theme_mode_light_dark.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://png.pngtree.com/thumb_back/fh260/background/20230612/pngtree-man-wearing-glasses-is-wearing-colorful-background-image_2905240.jpg'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Placeholder',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'EmailPlaceHolder',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 30, thickness: 1),
            // Menu items
            ZoomTapAnimation(
              child: ListTile(
                leading: Icon(Icons.event),
                title: Text("Mening tadbirlarim"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyEvents()));
                },
              ),
            ),
            ZoomTapAnimation(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text("Profil Ma'lumotlari"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to profile information screen
                },
              ),
            ),
            ZoomTapAnimation(
              child: ListTile(
                leading: Icon(Icons.language),
                title: Text("Tillarnio'zgartirish"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to language change screen
                },
              ),
            ),
            ZoomTapAnimation(
              child: ListTile(
                leading: Icon(Icons.brightness_6),
                title: Text("Tungi / kunduzgi holat"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              ),
            ),
            Spacer(),
            // Logout item
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text(
                "Chiqish",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await FirebaseAuthService.logoutUser();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
