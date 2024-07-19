import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserFirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsers() {
    return _firestore.collection('users').snapshots();
  }

  Future<void> addUser(String name, String? imageUrl) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String? email = FirebaseAuth.instance.currentUser!.email;
      String? token = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> data = {
        "user-uid": userId,
        "user-name": name,
        "user-imageUrl": imageUrl ?? '',
        'user-email': email,
        'user-token': token,
      };
      await _firestore.collection('users').add(data);
      print("/////////////////////////////////////////////User added successfully");
    } catch (e) {
      print("Error adding user: $e");
    }
  }
}
