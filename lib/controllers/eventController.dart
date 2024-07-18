import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/services/eventFirestoreService.dart';
import 'package:flutter/material.dart';

class EventController{
  final eventService = EventFireStoreService();

  Stream<QuerySnapshot> get list {
    return eventService.getEvents();
  }

  void addEvent({
    required String id,
    required String name,
    required DateTime eventDate,
    required String eventTime,
    required String location,
    required String eventReccomendation,
    required String imageUrl,
  })async {
    Map<String, dynamic> data = {
      'event-id': id,
      'event-name': name,
      'event-date': eventDate,
      'event-time': eventTime,
      'event-location': location,
      'event-reccomendation': eventReccomendation,
      'event-image-url': imageUrl,
    };
    print("Kirdih");
    await eventService.addEvent(data: data);
  }
  void deleteEvent({required String name}){
    eventService.delete(name: name);
  }
}
