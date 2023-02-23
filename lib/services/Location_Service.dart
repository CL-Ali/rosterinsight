import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationApi {
  static var _currentPosition;
  static var _destinationPosition;

  static Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permission permanently denied');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Permission denied');
      }
    }
    final position = await Geolocator.getCurrentPosition();
    _currentPosition = position;
  }

  static Future<void> getDestinationLocation(String zipCode) async {
    final locations = await locationFromAddress(zipCode);
    _destinationPosition = locations.first;
    //  Position(
    //   latitude: locations[0].latitude,
    //   timestamp: locations[0].timestamp,
    //   : locations[0].timestamp,
    //   longitude: locations[0].longitude,
    // );
  }

  static double calculateDistance() {
    final distance = Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      _destinationPosition.latitude,
      _destinationPosition.longitude,
    );
    return distance;
  }
}

    // _getDestinationLocation('SW1Y 6HD');
    // _getCurrentLocation();