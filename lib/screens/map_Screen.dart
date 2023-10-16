import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newfavoriteplaceapp/models/PlaceModel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
        latitude: 17.682310, longitude: 75.330901, address: ''),
    this.isSelecting = true,
  });
  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? pickedLoaction;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Choose location' : 'your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop(pickedLoaction);
                },
                icon: const Icon(Icons.save))
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  pickedLoaction = position;
                });
              },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 20,
        ),
        markers: (pickedLoaction == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('Marker1'),
                  position: pickedLoaction != null
                      ? pickedLoaction!
                      : LatLng(
                          widget.location.latitude,
                          widget.location.longitude,
                        ),
                ),
              },
      ),
    );
  }
}
