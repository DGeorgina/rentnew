import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;

class LocationService {
  final Function setDistance;

  LocationService({required this.setDistance});

  void calculateDistance(double lat2, double lon2) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    double? lat1 = _locationData.latitude;
    double? lon1 = _locationData.longitude;

    // double lat2 = 42.0046584;
    // double lon2 = 21.4092858;

    if (lat1 != null && lon1 != null) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      double distance = 12742 * asin(sqrt(a));

      setDistance(distance);
    }
  }
}
