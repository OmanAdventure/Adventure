import 'dart:async';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geocoding/geocoding.dart';
//import 'package:google_maps_webservice/places.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
//import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';


const kGoogleApiKey = 'AIzaSyBiSQed0ZY81EvHwkPX-UayuNT8rjXKivo';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class MapPickerScreen extends StatefulWidget {

  @override
  MapPickerScreenState createState() => MapPickerScreenState();
}

class MapPickerScreenState extends State<MapPickerScreen> {


  //final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  late LatLng _currentLocation;
  //late TextEditingController _searchController;
  bool _isLoading = true;
  //Search Places
  late GoogleMapController googleMapController;
//  final Mode _mode = Mode.overlay;                         // ------------Commented this
  late final String selectedCoordinatesBySearch = "";
  late final String locationTitleBySearch = "";

  //----------those variables to be passed to the previous screen------------
  late String selectedPlaceName;
  late double selectedPlaceLat = 0.0;
  late double selectedPlaceLng = 0.0;

/*
  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        logo: const Text(""),
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.white,) )),
        components: [Component(Component.country,"OM")]
    );

// only places in Oman
    displayPrediction(p!,homeScaffoldKey.currentState);


  }

  void onError(PlacesAutocompleteResponse response){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders()
    );
    if (p != null) {
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;
    final LatLng selectedCoordinatesBySearch = LatLng(lat, lng);
    final InfoWindow locationTitleBySearch = InfoWindow(
        title: detail.result.name, snippet: "");

    _markers.clear();
    _markers.add(Marker(markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    setState(()  {
      selectedPlaceName = p.description!;
      selectedPlaceLat = detail.result.geometry!.location.lat;
      selectedPlaceLng = detail.result.geometry!.location.lng;
      //final  selectedCoordinates = LatLng(selectedPlaceLat, selectedPlaceLng);
      print('@@@@@@@@@@@****1*******########  $locationTitleBySearch');
      print('@@@@@@@@@@@****2*******########  $selectedCoordinatesBySearch');
      googleMapController.animateCamera(CameraUpdate.newLatLngZoom(selectedCoordinatesBySearch, 18.0));
    });
  }
  }
*/
  //----------------------
  notifyTheUserToSearch() {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(""),
        content:    RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 16),
            children: [

              WidgetSpan(
                child: Column(
                  children: [
                    Row (
                      children: [
                        Text("Click the "),
                        Text(
                          String.fromCharCode(Icons.search.codePoint),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: Icons.search.fontFamily,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        Text(' icon'),
                        Text(' to search for'),
                      ],
                    ),
                    Text(' a location')
                  ],
                ),
              ),
            ],
          ),
        ),



        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    //_searchController = TextEditingController();
    _getCurrentLocation();

  }

  void _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      print('888 Current Location 88888 = $_currentLocation ');

      print('----------- $selectedPlaceLat');

      _isLoading = false;
      notifyTheUserToSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF700464),
        title: const Text("Pick a Location"),
        actions: [
          /*
          IconButton(
            onPressed:  _handlePressButton,
            icon:const Icon(Icons.search, size: 30,),
          ),
          */
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 400,
              child: GoogleMap(
                markers: _markers,
                mapType: MapType.normal,

                initialCameraPosition : CameraPosition(target: _currentLocation, zoom: 16.0),
                onMapCreated: (GoogleMapController controller) { googleMapController = controller; },
                trafficEnabled: true,

                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
          ),
          Padding (
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: SizedBox(
              width: double.infinity,
              child:  ElevatedButton(
                onPressed: () async {

                  // Check if the user has not selected a location
                  if (selectedPlaceLat  == 0.0) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Opps"),
                        content: const Text("Please select a location."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }

                  final selectedCoordinates = LatLng(selectedPlaceLat , selectedPlaceLng);
                  print('Selected Coordinates $selectedCoordinates');
                  print('Selected Place Name  $selectedPlaceName');

                  String Lat = selectedPlaceLat.toString();
                  String Lang = selectedPlaceLng.toString();
                  print('-==-=-=-=-=-=-==-=-=-=-=-=-=-=-==');
                  print('Latitude  $Lat');
                  print('Langitiude  $Lang');
                  Navigator.pop(context, [Lat, Lang, selectedPlaceName ]);

                  //   Navigator.pop(context, {
                  //     'Selected Coordinates': selectedCoordinates,
                  //      'Location Title ': selectedPlaceName,
                  //    });


                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20), backgroundColor: Color(0xFF700464),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Confirm"),
              ),
            ),
          ),
        ],
      ),
    );
  }




}


/*
This is a Flutter widget that displays a Google Map and allows the user to select a location on the map. The selected location is marked with a marker, and the latitude and longitude of the selected location are returned when the user taps the "check" button.

The widget uses the Google Maps Flutter package to display the map and the Geolocator package to obtain the current location of the user. The widget also includes a search bar that allows the user to search for a location by name or address. When the user enters a query in the search bar, the widget uses the Google Maps Places API to search for locations that match the query.

Here is an overview of the main methods in the widget:

_onMapTapped: Called when the user taps on the map. Clears the existing markers and adds a new marker at the tapped location.
_onSearchButtonPressed: Called when the user presses the search button. Uses the Google Maps Places API to search for the location entered in the search bar and adds a marker at the resulting location.
_getCurrentLocation: Called when the widget is initialized. Uses the Geolocator package to obtain the current location of the user.
build: Builds the UI of the widget, including the app bar, map, search bar, and "check" button.
Note that the widget uses a Completer to obtain a reference to the GoogleMapController when the map is created. This is necessary because the map is created asynchronously and the GoogleMapController is not available immediately. The Completer allows the widget to obtain the GoogleMapController when it is available.
*/


/*
This is a Flutter widget that displays a Google Map and allows the user to select a location on the map. The selected location is marked with a marker, and the latitude and longitude of the selected location are returned when the user taps the "check" button.

The widget uses the Google Maps Flutter package to display the map and the Geolocator package to obtain the current location of the user. The widget also includes a search bar that allows the user to search for a location by name or address. When the user enters a query in the search bar, the widget uses the Google Maps Places API to search for locations that match the query.

Here is an overview of the main methods in the widget:

_onMapTapped: Called when the user taps on the map. Clears the existing markers and adds a new marker at the tapped location.
_onSearchButtonPressed: Called when the user presses the search button. Uses the Google Maps Places API to search for the location entered in the search bar and adds a marker at the resulting location.
_getCurrentLocation: Called when the widget is initialized. Uses the Geolocator package to obtain the current location of the user.
build: Builds the UI of the widget, including the app bar, map, search bar, and "check" button.
Note that the widget uses a Completer to obtain a reference to the GoogleMapController when the map is created. This is necessary because the map is created asynchronously and the GoogleMapController is not available immediately. The Completer allows the widget to obtain the GoogleMapController when it is available.
*/
