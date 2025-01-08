// Dart/Flutter application code

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const ScheduleApp());
}

class ScheduleApp extends StatelessWidget {
  const ScheduleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Schedule App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ScheduleHomePage(),
    );
  }
}

class ScheduleHomePage extends StatefulWidget {
  const ScheduleHomePage({super.key});

  @override
  _ScheduleHomePageState createState() => _ScheduleHomePageState();
}

class _ScheduleHomePageState extends State<ScheduleHomePage> {
  final List<Map<String, dynamic>> _exams = [];
  final Location _location = Location();
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  void _addExam(Map<String, dynamic> exam) {
    setState(() {
      _exams.add(exam);
      _markers.add(
        Marker(
          markerId: MarkerId(exam['id']),
          position: LatLng(exam['latitude'], exam['longitude']),
          infoWindow: InfoWindow(
            title: exam['title'],
            snippet: '${exam['date']} @ ${exam['time']}',
          ),
        ),
      );
    });
  }

  Future<void> _showAddExamDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    final TextEditingController latitudeController = TextEditingController();
    final TextEditingController longitudeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exam Schedule'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time (HH:MM)'),
                ),
                TextField(
                  controller: latitudeController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                ),
                TextField(
                  controller: longitudeController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String id = DateTime.now().toIso8601String();
                _addExam({
                  'id': id,
                  'title': titleController.text,
                  'date': dateController.text,
                  'time': timeController.text,
                  'latitude': double.parse(latitudeController.text),
                  'longitude': double.parse(longitudeController.text),
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRouteToEvent(double latitude, double longitude) async {
    // Implement logic for route calculation using Google Maps API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Schedule'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: const CameraPosition(
              target: LatLng(41.9981, 21.4254), // Example coordinates (Skopje)
              zoom: 14,
            ),
            markers: _markers,
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _showAddExamDialog,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
