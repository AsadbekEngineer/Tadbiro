import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  String eventName;
  DateTime eventDate;
  String eventTime;
  String location;
  String eventReccomendation;
  String imageUrl;

  Event({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.eventReccomendation,
    required this.imageUrl
  });

  factory Event.fromQuerySnapshot(QueryDocumentSnapshot query){
    return Event(id: query['event-id'],
        eventName: query['event-name'],
        eventDate: (query['event-date'] as Timestamp).toDate(),
        eventTime: query['event-time'],
        location: query['event-location'],
        eventReccomendation: query['event-reccomendation'],
        imageUrl: query['event-image-url']);
  }
}