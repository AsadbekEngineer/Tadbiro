import 'dart:async';
import 'dart:io';

import 'package:exam/controllers/eventController.dart';
import 'package:exam/features/data/model/app_lat_long.dart';
import 'package:exam/features/data/service/app_location_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  /// Form key
  final _formKey = GlobalKey<FormState>();

  /// TextFieldForm Controllers
  final nameController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventTimeController = TextEditingController();
  final eventReccommendationController = TextEditingController();

  /// EventController
  final eventController = EventController();

  /// Yandex Map Controller
  final mapControllerCompleter = Completer<YandexMapController>();

  /// Uploading photo to Firestore
  File? pickedFile;
  String? url;

  /// Selected location on the map
  Point? selectedLocation;

  Future<void> uploadImage(String name) async {
    if (pickedFile != null) {
      url = await getDownloadUrl(name, pickedFile!);
    }
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    setState(() {
      pickedFile = File(result.files.first.path!);
    });
  }

  Future<String> getDownloadUrl(String name, File imageFile) async {
    try {
      final imagesImageStorage = FirebaseStorage.instance;
      final imageReference = imagesImageStorage
          .ref()
          .child("events")
          .child("images")
          .child("$name.jpg");
      final uploadTask = imageReference.putFile(imageFile);

      String imageUrl = '';
      await uploadTask.whenComplete(() async {
        imageUrl = await imageReference.getDownloadURL();
      });
      return imageUrl;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _initPermission();
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
  }
  Future<void> _moveToCurrentLocation(AppLatLong appLatLong) async {
    final controller = await mapControllerCompleter.future;
    controller.moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 12,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        eventDateController.text =
        pickedDate.toString().split(' ')[0]; // Format date properly
      });
    }
  }

  void _saveEvent() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      await uploadImage(UniqueKey().toString());
      eventController.addEvent(
        id: 'id',
        name: nameController.text,
        eventDate: DateTime.parse(eventDateController.text),
        eventTime: eventTimeController.text,
        location: selectedLocation != null
            ? '${selectedLocation!.latitude}, ${selectedLocation!.longitude}'
            : 'Unknown location',
        eventReccomendation: eventReccommendationController.text,
        imageUrl: url ?? 'https://images.pexels.com/photos/976866/pexels-photo-976866.jpeg?cs=srgb&dl=pexels-joshsorenson-976866.jpg&fm=jpg',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event saved successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save event: $error')),
      );
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        eventTimeController.text = pickedTime.format(context);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tadbir Qo'shish"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Nomi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          eventDateController.text.isEmpty
                              ? 'Kuni'
                              : eventDateController.text,
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                GestureDetector(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          eventTimeController.text.isEmpty
                              ? 'Vaqti'
                              : eventTimeController.text,
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 5),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: TextFormField(
                    maxLines: null,
                    expands: true,
                    controller: eventReccommendationController,
                    decoration: InputDecoration(
                      hintText: 'Tadbir Haqida Malumot',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some information';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 5),
                const Text("Pick Photo/Video"),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: selectFile,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        width: 172,
                        child: const Center(child: Icon(CupertinoIcons.camera)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        uploadImage(UniqueKey().toString());
                        print(UniqueKey().toString());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        width: 172,
                        child: const Center(
                          child: Icon(CupertinoIcons.video_camera, size: 32),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: YandexMap(
                    onMapCreated: (controller) {
                      mapControllerCompleter.complete(controller);
                      _fetchCurrentLocation();
                    },
                    onMapTap: (Point point) {
                      setState(() {
                        selectedLocation = point;
                        print(point);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _saveEvent,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Center(
                      child: Text("Saqlash"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
