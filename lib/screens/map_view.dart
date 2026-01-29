import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/club_model.dart';
import '../services/location_service.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import 'tariffs_screen.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    final position = await LocationService.getCurrentLocation();
    
    if (position != null) {
      final clubs = await ApiService.fetchNearbyClubs(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _markers = _buildMarkers(clubs);
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Set<Marker> _buildMarkers(List<ComputerClub> clubs) {
    return clubs.map((club) {
      return Marker(
        markerId: MarkerId(club.id),
        position: LatLng(club.lat, club.lng),
        infoWindow: InfoWindow(
          title: club.name,
          snippet: 'Tap to view details',
          onTap: () {
             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TariffsScreen(club: club),
              ),
            );
          },
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      );
    }).toSet();
  }

  static const String _mapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  }
]
''';

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.neonPurple))
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  style: _mapStyle,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition != null
                        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                        : const LatLng(41.311081, 69.240562),
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: _markers,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
          
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.cardBg.withAlpha(230),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(128),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.map, color: AppTheme.neonPurple),
                  const SizedBox(width: 12),
                  Text(
                    'EXPLORE CLUBS',
                    style: AppTheme.theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              onPressed: () async {
                final position = await LocationService.getCurrentLocation();
                if (position != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(position.latitude, position.longitude),
                    ),
                  );
                  // Optionally refresh clubs on move
                  final clubs = await ApiService.fetchNearbyClubs(position.latitude, position.longitude);
                  setState(() {
                    _markers = _buildMarkers(clubs);
                  });
                }
              },
              backgroundColor: AppTheme.neonPurple,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
