import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GooglesWidget extends StatefulWidget {
  const GooglesWidget({super.key});

  @override
  State<GooglesWidget> createState() => _GooglesWidgetState();
}

class _GooglesWidgetState extends State<GooglesWidget> {
  final LatLng najotTalim = const LatLng(41.2856806, 69.2034646);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: (CameraPosition(
          target: najotTalim,
        )),
      ),
    );
  }
}
