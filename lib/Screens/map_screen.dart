import 'package:flutter/material.dart';
import 'package:google_map_live_track/provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<LocationProvider>(builder: (context, getdata, child) {
      // Fetch distance data asynchronously
      getdata.getDistance();
      
      // Check if map data is still loading
      if (getdata.isMapLoading) {
        return const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            color: Colors.black,
          ),
        );
      }

      // Check if location data is available
      if (getdata.mainLocation == null || getdata.targetLocation == null) {
        return const Center(
          child: Text(
            'Location data not available',
            style: TextStyle(color: Colors.red),
          ),
        );
      }

      // Build the map screen
      return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                zoomGesturesEnabled: true,
                onMapCreated: getdata.onMapCreated,
                mapType: getdata.currentMapType,
                initialCameraPosition: CameraPosition(
                  target: getdata.targetLocation!,
                  zoom: 12,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('mainLocation'),
                    position: getdata.mainLocation!,
                    infoWindow: const InfoWindow(
                      title: 'xpertConsortium \n Technologies',
                      snippet: ' office location',
                      anchor: Offset(0, 0),
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta,
                    ),
                  ),
                  Marker(
                    markerId: const MarkerId('targetLocation'),
                    position: getdata.targetLocation!,
                    infoWindow: const InfoWindow(
                      title: 'User',
                      snippet: 'User current location',
                      anchor: Offset(0, 0),
                    ),
                  ),
                },
              ),
              Positioned(
                top: size.height * 0.03,
                right: size.width * 0.04,
                child: FloatingActionButton(
                  onPressed: getdata.switchMapViews,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.layers_outlined,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.05,
                right: size.width * 0.6,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Text(
                    "Distance: ${getdata.distance?.toStringAsFixed(2) ?? 'Unknown'} KM",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
