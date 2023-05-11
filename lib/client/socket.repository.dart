import 'package:flutter/material.dart';
import 'package:gooddelivary/client/socket_client.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  void joinToRoom(String orderId) {
    _socketClient.emit('join', orderId);
  }

  void deliveryPositionOnMap(Map<String, dynamic> delivaryPosition) {
    _socketClient.emit('deliveryPositionOnMap', delivaryPosition);
  }

  void saveDelivaryLocation(Map<String, dynamic> delivaryPosition) {
    _socketClient.emit('saveDelivaryPosition', delivaryPosition);
  }

  void changeListener(Function(Map<String, dynamic>) func) {
    _socketClient.on('changePosition', (data) => func(data));
  }

  void leaveChanel(String orderId, BuildContext context) {
    if (context.read<UserProvider>().user.type == 'user') {
      socketClient.disconnect();
    }
  }
}
