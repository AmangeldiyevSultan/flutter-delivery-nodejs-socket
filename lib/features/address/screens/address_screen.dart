import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:gooddelivary/common/config/api_keys.dart';
import 'package:gooddelivary/models/reciever_location.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../common/widgets/custom_textfield.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';
import '../services/address_services.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({
    Key? key,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressNameContoller = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();

  List<PaymentItem> paymentItems = [];
  final AddressServices addressServices = AddressServices();
  RecieverLocation recieverLocation = RecieverLocation();
  String _sessionToken = '122344';
  var uuid = const Uuid();
  List<dynamic> _placeList = [];
  Map<String, dynamic> _locationInfo = {};

  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        amount: widget.totalAmount,
        label: 'Total Amount',
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    pincodeController.dispose();
    phoneNumberController.dispose();
    addressNameContoller.dispose();
  }

  void onChangeLocationName() async {
    // ignore: prefer_conditional_assignment, unnecessary_null_comparison
    if (_sessionToken == null) {
      _sessionToken = uuid.v4();
    }
    _placeList = await AddressServices().getLocationAddress(
        addressName: addressNameContoller.text, sessionToken: _sessionToken);
  }

  void onApplePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: _locationInfo['placeInfo']);
    }
    addressServices.placeOrder(
      context: context,
      address: recieverLocation,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: _locationInfo['placeInfo']);
    }
    addressServices.placeOrder(
      context: context,
      address: recieverLocation,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void payPressed() {
    bool isForm = flatBuildingController.text.isNotEmpty &&
        pincodeController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty;

    if (!isForm) {
      if (_addressFormKey.currentState!.validate()) {
      } else {
        throw Exception('Please enter all the values!');
      }
    } else if (_locationInfo['placeInfo'] != null) {
      Map<String, dynamic> personalInfo = {
        'buidlingInfo': flatBuildingController.text,
        'pincode': pincodeController.text,
        'phoneNumber': phoneNumberController.text,
      };
      _locationInfo.addEntries(personalInfo.entries);
      recieverLocation = RecieverLocation.fromMap(_locationInfo);
    } else {
      showSnackBar(context, 'Choose correct address');
      throw Exception('lease enter all the values!');
    }
  }

  void getAddressCoordinates(Map<String, dynamic> place) async {
    GeoData addressCoordinatesGeoData = await Geocoder2.getDataFromAddress(
        address: place['description'], googleMapApiKey: kGoogleApi);
    _locationInfo = {
      'placeInfo': place['description'],
      'langitude': addressCoordinatesGeoData.latitude,
      'longitude': addressCoordinatesGeoData.longitude,
    };
    addressNameContoller.text = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomTextField(
                onChanged: (value) {
                  setState(() {
                    onChangeLocationName();
                  });
                },
                controller: addressNameContoller,
                hintText: _locationInfo['placeInfo'] ?? 'Address, Street',
                hintColor: _locationInfo['placeInfo'] != null
                    ? Colors.black
                    : Colors.black54,
              ),
              const SizedBox(
                height: 10,
              ),
              if (addressNameContoller.text.length > 2)
                SizedBox(
                  height: 300,
                  width: double.maxFinite,
                  child: ListView.separated(
                    itemCount: _placeList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: GestureDetector(
                          child: Text(_placeList[index]['description']),
                          onTap: () => getAddressCoordinates(_placeList[index]),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House, Building',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: phoneNumberController,
                      hintText: 'Phone Number',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              ApplePayButton(
                width: double.infinity,
                style: ApplePayButtonStyle.whiteOutline,
                type: ApplePayButtonType.buy,
                // ignore: deprecated_member_use
                paymentConfigurationAsset: 'applepay.json',
                onPaymentResult: onApplePayResult,
                paymentItems: paymentItems,
                margin: const EdgeInsets.only(top: 15),
                height: 50,
                onPressed: () => payPressed(),
              ),
              const SizedBox(height: 10),
              GooglePayButton(
                onPressed: () => payPressed(),
                // ignore: deprecated_member_use
                paymentConfigurationAsset: 'gpay.json',
                onPaymentResult: onGooglePayResult,
                paymentItems: paymentItems,
                height: 50,
                type: GooglePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15),
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
