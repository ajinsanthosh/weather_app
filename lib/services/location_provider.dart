import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/services/location_service.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;
  final LocationService _locationService = LocationService();

  Placemark? _currentLocationName;
  Placemark? get currentLocationName => _currentLocationName;

  Future<void> determinePosition() async {
    bool seviceEnable;
    LocationPermission premission;

    seviceEnable = await Geolocator.isLocationServiceEnabled();

    if (!seviceEnable) {
      _currentPosition = null;
      notifyListeners();
      return;
    }

    premission = await Geolocator.checkPermission();

    if (premission == LocationPermission.denied) {
      premission = await Geolocator.requestPermission();

      if (premission == LocationPermission.denied) {
        _currentPosition = null;
        notifyListeners();
        return;
      }
    }

    if (premission == LocationPermission.deniedForever) {
      _currentPosition = null;
      notifyListeners();
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition();
    print(_currentPosition);

    _currentLocationName = await _locationService.getLocationName(_currentPosition);

    print(_currentLocationName);

    notifyListeners();
  }
}
