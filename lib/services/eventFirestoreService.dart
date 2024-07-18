import 'package:cloud_firestore/cloud_firestore.dart';

class EventFireStoreService {
  // Map<String, dynamic> nimadir = {
  //   'haha' : 22,
  // };
  final eventCollection = FirebaseFirestore.instance.collection('events');

  Stream<QuerySnapshot> getEvents() async* {
    yield* eventCollection.snapshots();
  }



  Future<void> addEvent({required Map<String, dynamic> data}) async {
   await eventCollection.add(data);
   // await eventCollection.add(nimadir);
   //  print(nimadir);
  }

  void delete({required String name}) async {
    final querySnapshot =
        await eventCollection.where('event-name', isEqualTo: name).get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  }
}