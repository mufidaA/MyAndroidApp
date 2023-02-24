// ignore_for_file: depend_on_referenced_packages

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

Future<String> getAddressFromLatLng() async {
  Position currentPosition = await determinePosition();
  String currentAddress = ''; //
  try {
    List<Placemark> p = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark place = p[0];
    currentAddress = "${place.locality}, ${place.postalCode}, ${place.country}";
  } catch (e) {
    print(e);
    rethrow;
  }
  return currentAddress;
}

class UserAddess extends StatefulWidget {
  @override
  _UserAddress createState() => _UserAddress();
}

class _UserAddress extends State<UserAddess> {
  String _uadd = "";

  @override
  void initState() {
    getAddressFromLatLng().then((String address) {
      setState(() {
        _uadd = address;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.location_on),
                      if (_uadd != null)
                        Text('$_uadd',
                            style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ],
        ));
  }
}
