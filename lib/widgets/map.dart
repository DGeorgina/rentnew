import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.indigo[800],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Map',
          style: TextStyle(
            color: Colors.indigo[800],
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(42.0041, 21.4134),
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              const MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(42.0046584, 21.4092858),
                    width: 80,
                    height: 80,
                    child: Icon(Icons.pin_drop_outlined, color: Colors.deepPurple),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () {
                // launchGoogleMaps(pinLocation.latitude, pinLocation.longitude);
              },
              child: const Text('Navigate to Pin'),
            ),
          ),
        ],
      ),
    );
  }
}
