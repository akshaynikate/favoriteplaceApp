import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newfavoriteplaceapp/providers/users_places_provider.dart';
//import 'package:newfavoriteplaceapp/models/PlaceModel.dart';
import 'package:newfavoriteplaceapp/screens/AddPlaceScreen.dart';
import 'package:newfavoriteplaceapp/widgets/placesListWidget.dart';
//import 'package:riverpod/riverpod.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({super.key});
  @override
  ConsumerState<PlacesListScreen> createState() {
    return _PlacesListScreenState();
  }
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  late Future<void> placesFuture;
  @override
  void initState() {
    super.initState();
    placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: placesFuture,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return PlacesListWidget(places: userPlaces);
            })),
      ),
    );
  }
}
