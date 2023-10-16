import 'package:flutter/material.dart';
import 'package:newfavoriteplaceapp/models/PlaceModel.dart';
import 'package:newfavoriteplaceapp/screens/map_Screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});
  final Place place;
  String get locationImage {
    final lat = place.location.latitude;
    final long = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=Your API key';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(place.title),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MapScreen(
                                location: place.location, isSelecting: false),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            NetworkImage(locationImage, scale: 100),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      alignment: Alignment.center,
                      child: Text(place.location.address,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground)),
                    ),
                  ],
                ))
          ],
        ));
  }
}
