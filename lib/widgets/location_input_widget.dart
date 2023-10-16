import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:newfavoriteplaceapp/main.dart';
import 'package:newfavoriteplaceapp/models/PlaceModel.dart';
import 'package:newfavoriteplaceapp/screens/map_Screen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectedLoction});
  final void Function(PlaceLocation location) onSelectedLoction;
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? picekdLocation;
  String get locationImage {
    if (pickedlocation == null) {
      return '';
    }
    final lat = pickedlocation!.latitude;
    final long = pickedlocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=Your API key';
  }

  PlaceLocation? pickedlocation;
  var isGettingLoaction = false;

  Future<void> _savePlace(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=Your API key');
    final response = await http.get(url);
    final data = json.decode(response.body);
    final address = data['results'][0]['formatted_address'];

    setState(() {
      pickedlocation = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: address,
      );
      isGettingLoaction = false;
    });
    widget.onSelectedLoction(pickedlocation!);
  }

  void getCurrentLoaction() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isGettingLoaction = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;
    if (lat == null || long == null) {
      return;
    }
    _savePlace(lat, long);
  }

  void selectOnMap() async {
    final _pickedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );
    if (_pickedLocation == null) {
      return;
    }
    _savePlace(_pickedLocation.latitude, _pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget privewContent = Text(
      'No loaction choosen',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: colorScheme.onBackground),
    );
    if (isGettingLoaction) {
      privewContent = const CircularProgressIndicator();
    }
    if (pickedlocation != null) {
      privewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
      );
    }
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Center(child: privewContent),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLoaction,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Location'),
            ),
            TextButton.icon(
              onPressed: selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Map'),
            )
          ],
        )
      ],
    );
  }
}
