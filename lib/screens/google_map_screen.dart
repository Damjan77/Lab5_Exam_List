import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lab3_exams_193222/models/list_exam.dart';
import 'package:lab3_exams_193222/services/notifications.dart';

class GoogleMapPage extends StatefulWidget {
  static const String id = "googleMapScreen";
  final List<ListExam> exams;
  GoogleMapPage(this.exams);
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState(exams);
}

class _GoogleMapPageState extends State<GoogleMapPage> {

  final NotificationService service = NotificationService();
  final List<Marker> markers = <Marker>[];
  List<ListExam> exams;
  _GoogleMapPageState(this.exams);
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _createMarkersForExams(exams);
  }


  void _createMarkersForExams(exams) {
    for(var i=0; i<exams.length; i++) {
      markers.add(Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(exams[i].location.latitude, exams[i].location.longitude),
          infoWindow: InfoWindow(
            title: exams[i].subject,
            snippet: DateFormat("yyyy-MM-dd HH:mm:ss").format(exams[i].dateTime),
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: (){
            getUserCurrentLocation().then((userLocation) async {
              LatLng destinationLocationCoordinates = LatLng(exams[i].location.latitude, exams[i].location.longitude);
              LatLng userLocationCoordinates = LatLng(userLocation.latitude, userLocation.longitude);
              _findTheShortestRoute(userLocationCoordinates, destinationLocationCoordinates);
            });
          }
      ));
    }
    print("Number of markers created: " + markers.length.toString());
  }


  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition camera = const CameraPosition(
    target: LatLng(42.00478491557928, 21.40917442067392),
    zoom: 14.4746,
  );

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  void _findTheShortestRoute(LatLng userLocation, LatLng destinationLocation) async{
    print("Finding shortest route for destination");
    PolylinePoints polylinePoints = PolylinePoints();
    String googleAPI = 'AIzaSyAVdAlhV1OVRX-W2RCjyjBUUf841sK3auA';

    addPolyLine(List<LatLng> polylineCoordinates) {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.deepOrange,
        points: polylineCoordinates,
        width: 8,
      );
      polylines[id] = polyline;
      setState(() {});
    }

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPI,
      PointLatLng(userLocation.latitude, userLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF9D960F),
        title: Text("Google Map Page"),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: camera,
            markers: Set<Marker>.of(markers),
            polylines: Set<Polyline>.of(polylines.values),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() +" "+value.longitude.toString());
            
            CameraPosition cameraPosition = new CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );

            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {
            });
          });
        },
        child: Icon(Icons.map_sharp),
      ),
    );
  }
}