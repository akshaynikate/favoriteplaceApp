import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newfavoriteplaceapp/models/PlaceModel.dart';
import 'package:newfavoriteplaceapp/providers/users_places_provider.dart';
import 'package:newfavoriteplaceapp/widgets/image_input_widget.dart';
import 'package:newfavoriteplaceapp/widgets/location_input_widget.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({
    super.key,
  });

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? selectedImage;
  PlaceLocation? selectedLocation;
  void _savePlace() {
    if (_titleController.text.isEmpty ||
        selectedImage == null ||
        selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
      return;
    }

    ref
        .read(userPlacesProvider.notifier)
        .addPlace(_titleController.text, selectedImage!, selectedLocation!);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Places'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              controller: _titleController,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 10,
            ),
            ImageInputWidget(onSelectImage: (image) {
              selectedImage = image;
            }),
            LocationInput(
              onSelectedLoction: (location) {
                selectedLocation = location;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: _savePlace,
              label: const Text('Add Place'),
              icon: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
