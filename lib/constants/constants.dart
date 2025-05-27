// ignore_for_file: non_constant_identifier_names

import 'package:geolocator/geolocator.dart';

final double APPBAR_HEIGHT = 90.0;
final double NAVBAR_HEIGHT = 110.0;

final double NAVBAR_ICON_WIDTH = 30.0;


// store list with coordinates (example data)
final List<Map<String, dynamic>> STORES = [
  {
    'name': 'Lidl',
    'score': 4.5,
    'adress' : '44 rue Lucien Faure, 33000 Bordeaux',
    'position': Position(
      latitude: 44.862232, 
      longitude: -0.555781,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    )
  },
  {
    'name': 'Monoprix',
    'score': 3.5,
    'adress' : '10 rue Lucien Faure, 33000 Bordeaux',
    'position': Position(
      latitude: 44.860888,
      longitude: -0.554968,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    )
  },
  {
    'name': 'Intermarche',
    'score': 4.0,
    'adress' : '67 Cr Edouard Vaillant, 33300 Bordeaux',
    'position': Position(
      latitude: 44.861037,
      longitude: -0.558407,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    )
  },
];

List<Map<String, dynamic>> getBestStores(Position? userPosition) {
  if (userPosition == null) return [];
  final List<Map<String, dynamic>> scoredStores = STORES.map((store) {
    final storePos = store['position'] as Position;
    final distance = Geolocator.distanceBetween(
      userPosition.latitude,
      userPosition.longitude,
      storePos.latitude,
      storePos.longitude,
    );
    final score = store['score'] ?? 0.0;
    return {
      ...store,
      'distance': distance,
      'scorePerKm': distance > 0 ? score / distance : 0,
    };
  }).toList();

  scoredStores.sort((a, b) => (b['scorePerKm'] as double).compareTo(a['scorePerKm'] as double));
  return scoredStores;
}