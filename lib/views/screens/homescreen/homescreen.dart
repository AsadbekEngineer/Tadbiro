import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam/controllers/eventController.dart';
import 'package:exam/models/eventModel.dart';
import 'package:exam/views/screens/addEventScreen/add_event_screen.dart';
import 'package:exam/views/screens/myEvents/myEventsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final eventController = EventController();
  final List<Event> _events = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyEvents()));
                  },
                  child: Text("Mening dasturlarim"))
            ],
          ),
        )
      ),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.bell))
        ],
        title: Text("Bosh Sahifa"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefix: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
              ),
              items: [1, 2, 3, 4, 5].map((e) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: eventController.list,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData || snapshot.hasError) {
                    return Center(
                      child: Center(
                        child: Text("Malumot mavjud emas"),
                      ),
                    );
                  } else {
                    _events.clear();
                    var data = snapshot.data!.docs;
                    for (var each in data) {
                      _events.add(Event.fromQuerySnapshot(each));
                    }
                    return ListView.builder(
                      itemExtent: 80.0,
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey)),
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                          height: 100,
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 65,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.eventName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${event.eventDate.day}-${event.eventDate.month}-${event.eventDate.year}",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
