import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(43.4643, -80.5204); // Coordinates for Waterloo
  Set<Marker> _markers = {}; // Store parking location markers

  @override
  void initState() {
    super.initState();
    _fetchParkingLocations();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Function to fetch parking locations using Google Places API
  Future<void> _fetchParkingLocations() async {
    const apiKey = "YOUR_API_KEY_HERE";
    const radius = 5000; // 5km radius
    final url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=43.4643,-80.5204&radius=$radius&type=parking&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        Set<Marker> parkingMarkers = {};

        for (var place in results) {
          final location = place['geometry']['location'];
          final markerId = place['place_id'];
          final marker = Marker(
            markerId: MarkerId(markerId),
            position: LatLng(location['lat'], location['lng']),
            infoWindow: InfoWindow(
              title: place['name'],
              snippet: place['vicinity'],
            ),
            onTap: () {
              _confirmParkingLocation(
                place['name'],
                place['vicinity'],
                LatLng(location['lat'], location['lng']),
              );
            },
          );
          parkingMarkers.add(marker);
        }

        setState(() {
          _markers = parkingMarkers;
        });
      } else {
        log("Failed to load parking locations: ${response.statusCode}", name: "MapScreen");
      }
    } catch (e) {
      log("Error fetching parking locations: $e", name: "MapScreen");
    }
  }

  // Function to confirm parking location selection
  void _confirmParkingLocation(String name, String vicinity, LatLng position) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Parking Location'),
        content: Text('Do you want to select "$name" at "$vicinity" as your parking location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Return selected address to the previous screen
              Navigator.pop(context); // Close the dialog
              Navigator.pop(context, "$name, $vicinity"); // Send data back
            },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Parking Location'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        markers: _markers,
      ),
    );
  }
}
