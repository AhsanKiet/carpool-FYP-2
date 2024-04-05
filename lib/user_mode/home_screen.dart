import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/rider_mode/home_screen.dart';
import 'package:flutter_application_1/user_mode/places_response_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_application_1/credentials/login_screen.dart';
import 'view_schedules.dart';
import 'userprofile.dart';
import 'package:flutter_application_1/rider_mode/car_info.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleMapController? mapController;
  final Location _locationController = Location();

  // LatLng? _currentP = null;
  String? selectedCarType;
  String? selectedPassengerType;
  List<String> carTypes = ['Car AC', 'Car Non-AC'];
  List<String> passengerTypes = ['1', '2', '3', '4'];
  static LocationData? _locationData;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    getLocation();
  }

  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  // late GoogleMapController _googleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 20,
  );
  static LatLng sourceLocation = LatLng(24.920733, 67.088162);
  static LatLng destinationLocation = LatLng(24.926295, 67.130499);
  List<Polyline> polylines = [];
  List<LatLng> polylineCoordinates = [];

  static double currentLat = 24.920733;
  static double currentLng = 67.088162;
  static String locationDataInString = "";
  List<Marker> markers = [];

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = <LatLng>[];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
    }
    return points;
  }

  Location location = Location();

  static String _displayStringForOption(PlacesResponse option) => option.name;

  Future<void> getLocation() async {
    BitmapDescriptor customMarker = BitmapDescriptor.defaultMarker;

    _locationData = await location.getLocation();
    print(
        'Latitude: ${_locationData!.latitude}, Longitude: ${_locationData!.longitude}');
    currentLat = _locationData!.latitude!.toDouble();
    currentLng = _locationData!.longitude!.toDouble();
    locationDataInString = await getLocationName(
      _locationData!.latitude!.toDouble(),
      _locationData!.longitude!.toDouble(),
    );

    // markers.add(Marker(
    //     markerId: MarkerId('whereami'),
    //     position: LatLng(currentLat, currentLng),
    //     icon: customMarker));
    // sourceTextEditingController.text = locationDataInString;

    setState(() {});
    log("-----------------location data" + locationDataInString.toString());
  }

  Future<String> getLocationName(double latitude, double longitude) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['display_name'];
    } else {
      throw Exception('Failed to load location data');
    }
  }

  Future<List<PlacesResponse>> getPlaces(String value) async {
    String API_KEY = "AIzaSyCdLAHV2BMZg_vfQcb8PZc9WggHr0w_U0A";
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=" +
            API_KEY +
            "&query=" +
            value;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> results = data['results'];
      List<PlacesResponse> resp =
          results.map((json) => PlacesResponse.fromJson(json)).toList();
      print(resp);
      return resp;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
    //return const Iterable<String>.empty();
  }

  void MoveCameraLocation(CameraPosition? pos) {
    if (pos != null) {
      newGoogleMapController?.moveCamera(
        CameraUpdate.newCameraPosition(pos),
      );
    } else {
      newGoogleMapController?.moveCamera(
        CameraUpdate.newCameraPosition(_kGooglePlex),
      );
    }
    setState(() {});
  }

  Future<List<Polyline>> fetchAlternateRoutes() async {
    List<Color> colors = [
      Colors.blue,
      const Color.fromARGB(255, 123, 163, 160),
      Colors.orange
    ];
    List<Polyline> _temp = [];
    // Replace 'YOUR_API_KEY' with your actual Google Directions API key
    String apiKey = 'AIzaSyCdLAHV2BMZg_vfQcb8PZc9WggHr0w_U0A';
    String origin =
        "${sourceLocation.latitude},${sourceLocation.longitude}"; // Replace with origin lat,long
    String destination =
        "${destinationLocation.latitude},${destinationLocation.longitude}"; // Replace with destination lat,long

    print("start ${origin} : end ${destination}");

    // Request different routes by specifying different `alternatives` parameter values
    List<String> alternatives = [
      'true',
    ]; // For example, fetching two alternate routes

    for (String alternative in alternatives) {
      String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&alternatives=$alternative&key=$apiKey';

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['routes'] != null) {
          List<dynamic> routes = data['routes'];
          print(routes.length);
          for (var route in routes) {
            if (_temp.length == 2) break;
            String points = route['overview_polyline']['points'];
            print(points);
            List<LatLng> decodedPoints = decodePolyline(points);
            //polylineCoordinates.addAll(decodedPoints);
            for (var element in decodedPoints) {
              print("${element.latitude},${element.longitude}");
            }

            Polyline polyline = Polyline(
              polylineId: PolylineId('route_${_temp.length}'),
              points: decodedPoints,
              color: colors[_temp.length],
              width: 6,
            );

            // setState(() {
            _temp.add(polyline);

            // });
          }
        }
      }

      print(_temp);
      return _temp;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green[300],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            // zoomControlsEnabled: false,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.from(markers),
            polylines: Set<Polyline>.from(polylines),
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              const Marker(
                  markerId: MarkerId("_destinationLocation"),
                  icon: BitmapDescriptor.defaultMarker);
              Marker(
                  markerId: const MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(currentLat, currentLng));
              const Marker(
                  markerId: MarkerId("_sourceLocation"),
                  icon: BitmapDescriptor.defaultMarker);
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              height: 350,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Autocomplete<PlacesResponse>(
                    displayStringForOption: _displayStringForOption,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<PlacesResponse>.empty();
                      }

                      return getPlaces(textEditingValue.text);
                    },
                    onSelected: (PlacesResponse selection) {
                      setState(() {
                        sourceLocation = LatLng(selection.lat, selection.lng);
                        polylines.clear();
                        polylineCoordinates.clear();
                        markers.removeWhere(
                          (element) =>
                              element.markerId ==
                              MarkerId(
                                "S",
                              ),
                        );
                        markers.add(
                          Marker(
                              markerId: MarkerId("S"),
                              position: sourceLocation,
                              infoWindow: InfoWindow(title: selection.name)),
                        );
                        MoveCameraLocation(CameraPosition(
                          target: LatLng(selection.lat, selection.lng),
                          zoom: 17.5,
                        ));

                        //API CALL
                      });
                      debugPrint('You just selected ${(selection.name)}');
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController _sourceTextEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: _sourceTextEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Pick Up Location',
                          prefixIcon: const Icon(Icons.location_on),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  const SizedBox(height: 9.0),
                  Autocomplete<PlacesResponse>(
                    displayStringForOption: _displayStringForOption,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<PlacesResponse>.empty();
                      }

                      return getPlaces(textEditingValue.text);
                    },
                    onSelected: (PlacesResponse selection) {
                      destinationLocation =
                          LatLng(selection.lat, selection.lng);
                      //getploypoints();
                      polylines.clear();
                      var cameraPosition = CameraPosition(
                        target: LatLng(destinationLocation.latitude,
                            destinationLocation.longitude),
                        zoom: 11,
                      );
                      markers.add(Marker(
                          markerId: MarkerId("D"),
                          position: destinationLocation,
                          infoWindow: InfoWindow(title: selection.name)));

                      setState(() {});
                      fetchAlternateRoutes().then((lines) => {
                            for (var element in lines)
                              {polylines.add(element), setState(() {})}
                          });
                      MoveCameraLocation(cameraPosition);

                      debugPrint('You just selected ${(selection.name)}');
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Drop Off Location',
                          prefixIcon: const Icon(Icons.pin_drop),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  const SizedBox(height: 9.0),
                  DropdownButtonFormField<String>(
                    value: selectedPassengerType,
                    onChanged: (value) {
                      setState(() {
                        selectedPassengerType = value;
                      });
                    },
                    items: passengerTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child:
                            Text(type, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Passengers',
                      prefixIcon: Icon(Icons.people),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 9.0),
                  DropdownButtonFormField<String>(
                    value: selectedCarType,
                    onChanged: (value) {
                      setState(() {
                        selectedCarType = value;
                      });
                    },
                    items: carTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child:
                            Text(type, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Choose Car Type',
                      prefixIcon: Icon(Icons.car_rental),
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      backgroundColor: Colors.green[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      fixedSize: const Size(300.0, 50.0),
                    ),
                    child: const Text('Find a driver',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: fetchUserName(),
          builder: (context, snapshot) {
            String userName = snapshot.data ?? "User";
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        userName,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Update Profile'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileManagement(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text('History'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Schedules'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewSchedulesScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.book),
                  title: Text('Bookings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sign out'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text('Driver mode'),
                    onTap: () async {
                      User? user = _auth.currentUser;
                      if (user != null) {
                        final DatabaseReference Ref = FirebaseDatabase.instance
                            .reference()
                            .child('drivers/${user.uid}/car_details');
                        Ref.onValue.listen((event) {
                          final DataSnapshot snapshot = event.snapshot;
                          final Map<dynamic, dynamic>? values =
                              snapshot.value as Map?;
                          if (values != null) {
                            // User data exists under 'car_details' node
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MainScreene(),
                              ),
                            );
                          } else {
                            // User data doesn't exist under 'car_details' node
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CarInfoScreen(),
                              ),
                            );
                          }
                        });
                      }
                    }),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }
    // _locationController.onLocationChanged.listen((LocationData currentLocation) {
    //   if (currentLocation.latitude != null &&
    //       currentLocation.longitude != null) {
    //     setState(() {
    //       _currentP =
    //           LatLng(currentLocation.latitude!, currentLocation.longitude!);
    //       print(_currentP);
    //     });
    //   }
    // });
  }

  Future<String?> fetchUserName() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final DatabaseReference userRef =
          FirebaseDatabase.instance.reference().child('users/${user.uid}/name');

      DatabaseEvent event = await userRef.once(); // Use DatabaseEvent

      if (event.snapshot.value != null) {
        return event.snapshot.value.toString(); // Access snapshot property
      }
    }
    return null;
  }
}
