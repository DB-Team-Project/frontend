import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  Location _location = Location();
  Set<Marker> _markers = {};
  String _selectedCategory = 'ALL';

  @override
  void initState() {
    super.initState();
    _requestPermission();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _controller?.animateCamera(CameraUpdate.newLatLng(
        LatLng(currentLocation.latitude!, currentLocation.longitude!),
      ));
      _fetchStores(currentLocation.latitude!, currentLocation.longitude!);
    });
  }

  void _requestPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void _fetchStores(double latitude, double longitude) async {
    const url = 'http://192.168.242.51:8080/api/location';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'latitude': latitude,
        'longitude': longitude,
        'distance': 1000,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(jsonString);
      final stores = jsonData['stores'] as List<dynamic>;

      setState(() {
        _markers.clear();
        for (var store in stores) {
          final marker = Marker(
            markerId: MarkerId(store['storeId'].toString()),
            position: LatLng(store['latitude'], store['longitude']),
            infoWindow: InfoWindow(title: store['storeName']),
            // visible 속성을 동적으로 변경
            visible: _selectedCategory == 'ALL' || store['category'] == _selectedCategory,
            onTap: () {
              _fetchStoreDetails(store['storeId'].toString());
            },
          );
          print('marker: ${store['categoryName'].toString()}');
          _markers.add(marker);
        }
      });
    }
  }

  void _fetchStoreDetails(String storeId) async {
    final url = 'http://192.168.242.51:8080/api/location/$storeId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(jsonString);
      _showStoreDetailsDialog(jsonData);
    }
  }

  void _showStoreDetailsDialog(Map<String, dynamic> storeData) {
    final avgRating = storeData['avgRating'];
    final roundedRating = avgRating.round();

    final stars = List.generate(5, (index) {
      if (index < roundedRating) {
        return Icon(Icons.star, color: Colors.amber);
      } else {
        return Icon(Icons.star_border, color: Colors.grey);
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(storeData['storeName']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(storeData['description']),
                SizedBox(height: 8),
                Row(
                  children: stars,
                ),
                SizedBox(height: 8),
                Text('위치: ${storeData['location']}'),
                SizedBox(height: 16),
                Text('리뷰:'),
                Column(
                  children: (storeData['reviews'] as List<dynamic>)
                      .map((review) => ListTile(
                    title: Text(review['memberName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('평점: ${review['rating']}'),
                        Text(review['reviewText']),
                        Text(review['modifiedDate'])
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.77483, -122.41942),
    zoom: 15,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.terrain,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _location.getLocation().then((location) {
                _controller?.animateCamera(CameraUpdate.newLatLng(
                  LatLng(location.latitude!, location.longitude!),
                ));
                _fetchStores(location.latitude!, location.longitude!);
              });
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'ALL';
                      });
                      _location.getLocation().then((location) {
                        _fetchStores(location.latitude!, location.longitude!);
                      });
                    },
                    child: Text('All'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'RESTAURANT';
                      });
                      _location.getLocation().then((location) {
                        _fetchStores(location.latitude!, location.longitude!);
                      });
                    },
                    child: Text('Restaurant'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'CAFE';
                      });
                      _location.getLocation().then((location) {
                        _fetchStores(location.latitude!, location.longitude!);
                      });
                    },
                    child: Text('Cafe'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'BAR';
                      });
                      _location.getLocation().then((location) {
                        _fetchStores(location.latitude!, location.longitude!);
                      });
                    },
                    child: Text('Bar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'ETC';
                      });
                      _location.getLocation().then((location) {
                        _fetchStores(location.latitude!, location.longitude!);
                      });
                    },
                    child: Text('Etc'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}