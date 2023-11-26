import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late CameraPosition _currentPosition;
  late Marker _currentMarker;
  late bool _locationServiceEnabled;
  late LocationPermission _permission;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _polygon.add(Polygon(
      polygonId: const PolygonId('1'),
      points: points,
      fillColor: Colors.red.withOpacity(0),
      geodesic: true,
      strokeWidth: 2,
      strokeColor: Colors.blue,
    ));
  }

  void _determinePosition() async {
    _locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_locationServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 24,
      );
      _currentMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(
          title: 'Current Location',
        ),
      );
    });
  }

  final Completer<GoogleMapController> _controller = Completer();

  final Set<Polygon> _polygon = HashSet<Polygon>();

  List<LatLng> points = [
    const LatLng(4.5885 + 0.0001, 101.1260 + 0.0001),
    const LatLng(4.5885 + 0.0001, 101.1260 - 0.0001),
    const LatLng(4.5885 - 0.0001, 101.1260 - 0.0001),
    const LatLng(4.5885 - 0.0001, 101.1260 + 0.0001),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: {_currentMarker},
        mapType: MapType.normal,
        initialCameraPosition: _currentPosition,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        polygons: _polygon,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
