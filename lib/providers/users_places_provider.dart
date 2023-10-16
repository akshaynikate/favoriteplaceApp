import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newfavoriteplaceapp/models/PlaceModel.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDataBase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbpath, 'paces.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,lat REAL,lng REAL,address TEXT)');
  }, version: 1);
  return db;
}

class UserPlacesNotifire extends StateNotifier<List<Place>> {
  UserPlacesNotifire() : super(const []);
  Future<void> loadPlaces() async {
    final db = await _getDataBase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');
    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );
    final db = await _getDataBase();
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifire, List<Place>>(
        (ref) => UserPlacesNotifire());
