import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gooddelivary/client/socket.repository.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/constants/utils.dart';
import 'package:gooddelivary/models/delivary_position.dart';
import 'package:gooddelivary/models/order.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData locationData;
  DelivaryPosition delivaryPosition = DelivaryPosition();
  StreamSubscription<LocationData>? _locationSubscription;
  SocketRepository socketRepository = SocketRepository();
  bool getCloseDelivery = false;
  bool finishDelivery = false;
  double distance = 100;
  Timer? _locationSaveTimer;
  Map<String, dynamic> locationInfo = {};

  Future<bool> _handleLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void getCurrentLocation(String name, Order order) async {
    bool hasPermission = await _handleLocationPermission();
    if (hasPermission) {
      location.enableBackgroundMode(enable: true);
      if (!socketRepository.socketClient.connected) {
        socketRepository.joinToRoom(order.id);
      }

      _locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
        locationData = currentLocation;
        if (kDebugMode) {
          print(currentLocation);
        }
        distance = calculateDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            order.address.langitude,
            order.address.longitude);
        getCloseDelivery = distance < 1 ? true : false;
        finishDelivery = distance < 0.2 ? true : false;

        locationInfo = {
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
          'name': name,
          'room': order.id,
          'rotation':
              currentLocation.heading == 0 ? 0.1 : currentLocation.heading,
          'getClose': getCloseDelivery,
          'finish': finishDelivery,
          'distance': distance,
          'client_id': order.userId,
          'uri': uri
        };
        socketRepository.deliveryPositionOnMap(locationInfo);
        if (_locationSaveTimer == null || !_locationSaveTimer!.isActive) {
          _locationSaveTimer = Timer(const Duration(seconds: 4),
              () => socketRepository.saveDelivaryLocation(locationInfo));
        }
        notifyListeners();
      });
    }
  }

  void stopListeningToLocationUpdates() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
      _locationSubscription = null;
      _locationSaveTimer?.cancel();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
