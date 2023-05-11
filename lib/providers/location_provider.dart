import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gooddelivary/client/socket.repository.dart';
import 'package:gooddelivary/client/socket_client.dart';
import 'package:gooddelivary/models/delivary_position.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData locationData;
  DelivaryPosition delivaryPosition = DelivaryPosition();
  StreamSubscription<LocationData>? _locationSubscription;
  SocketRepository socketRepository = SocketRepository();

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

  void getCurrentLocation(String name, String orderId) async {
    bool hasPermission = await _handleLocationPermission();
    if (hasPermission) {
      location.enableBackgroundMode(enable: true);
      print("GETCURRENTLOCATION");
      print(socketRepository.socketClient.connected);
      if (!socketRepository.socketClient.connected) {
        socketRepository.joinToRoom(orderId);
      }

      _locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
        locationData = currentLocation;
        print(currentLocation);
        Map<String, dynamic> locationInfo = {
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
          'name': name,
          'room': orderId,
          'rotation':
              currentLocation.heading == 0 ? 0.1 : currentLocation.heading,
        };

        socketRepository.deliveryPositionOnMap(locationInfo);
        socketRepository.saveDelivaryLocation(locationInfo);
      });
    }
  }

  void stopListeningToLocationUpdates() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
      _locationSubscription = null;
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
}
