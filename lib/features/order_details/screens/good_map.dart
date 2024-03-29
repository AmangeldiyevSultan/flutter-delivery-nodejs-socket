import 'package:flutter/material.dart';
import 'package:gooddelivary/client/socket.repository.dart';
import 'package:gooddelivary/constants/global_variables.dart';
import 'package:gooddelivary/models/order.dart';
import 'package:gooddelivary/providers/location_provider.dart';
import 'package:gooddelivary/providers/user_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoodMap extends StatefulWidget {
  static const routeName = '/goodmap';
  final Order orderParams;

  const GoodMap({super.key, required this.orderParams});

  @override
  State<GoodMap> createState() => _GoodMapState();
}

class _GoodMapState extends State<GoodMap> {
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;
  SocketRepository socketRepository = SocketRepository();

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/delivery.png")
        .then((icon) => currentIcon = icon);
  }

  GoogleMapController? _googleMapController;
  Map<String, dynamic> deliveryPosition = {};

  @override
  void initState() {
    super.initState();

    setCustomMarkerIcon();

    deliveryPosition = {
      'latitude': widget.orderParams.deliveryPosition!.latitude ?? 0.0,
      'longitude': widget.orderParams.deliveryPosition!.longitude ?? 0.0,
      'rotation': 0.0,
    };

    if (!socketRepository.socketClient.connected) {
      socketRepository.joinToRoom(widget.orderParams.id);
    }

    if (mounted) {
      socketRepository.changeListener((data) {
        if (mounted) {
          deliveryPosition = {
            'latitude': data['latitude'],
            'longitude': data['longitude'],
            'rotation': data['rotation'],
          };
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    _googleMapController!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back)),
          title: Text(
              'Courier: ${widget.orderParams.deliveryPosition?.name ?? 'Loading..'}'),
        ),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.orderParams.address.langitude!,
                widget.orderParams.address.longitude!),
            zoom: 13.5),
        markers: {
          Marker(
              markerId: const MarkerId('reciever'),
              position: LatLng(widget.orderParams.address.langitude!,
                  widget.orderParams.address.longitude!)),
          if (widget.orderParams.deliveryPosition?.name != null)
            Marker(
                markerId: const MarkerId('deliveryMan'),
                icon: currentIcon,
                rotation: deliveryPosition['rotation'],
                position: userProvider.user.type == 'admin'
                    ? LatLng(locationProvider.locationInfo['latitude'] ?? 0.0,
                        locationProvider.locationInfo['longitude'] ?? 0.0)
                    : LatLng(deliveryPosition['latitude'],
                        deliveryPosition['longitude']))
        },
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
      ),
    );
  }
}
