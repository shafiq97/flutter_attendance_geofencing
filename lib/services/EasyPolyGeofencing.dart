import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../model/lat_lng.dart';
import '../model/poly_utils.dart';
import '../model/user.dart';
import 'enums/geofence_status.dart';

////
///  Geofence Package [ROOT] class which have [three] important public
///  functions [startGeoFenceService(),stopGeoFenceService(),getGeoFenceStream()]
///
class EasyPolyGeofencing {
  ///
  /// [ _positionStream ] is for getting stream position on location updates
  ///
  static StreamSubscription<Position>? _positionStream;

  ///
  /// [_geostream] is for geofence event stream
  ///
  static Stream<GeofenceStatus>? _geoFencestream;

  ///
  /// [_controller] is Stream controller for geofence event stream
  ///
  static StreamController<GeofenceStatus> _controller =
  StreamController<GeofenceStatus>();


  ///
  /// For [getting geofence event stream] property which is basically returns [_geostream]
  ///
  static Stream<GeofenceStatus>? getGeofenceStream() {
    return _geoFencestream;
  }

  ///
  /// [startGeofenceService] To start the geofence service
  /// this method takes this required following parameters
  /// pointedLatitude is the latitude of geofencing area center which is [String] datatype
  /// pointedLongitude is the longitude of geofencing area center which is [String] datatype
  /// radiusMeter is the radius of geofencing area in meters
  /// radiusMeter takes value is in [String] datatype and
  /// eventPeriodInSeconds will determine whether the stream listener period in seconds
  /// eventPeriodInSeconds takes value in [int]
  /// The purpose of this method is to initialize and start the geofencing service.
  /// At first it will check location permission and if enabled then it will start listening the current location changes
  /// then calculate the distance of changes point to the allocated geofencing area points
  ///
  static startGeofenceService(
      {int? eventPeriodInSeconds}) {
    //parsing the values to double if in any case they are coming in int etc
    //starting the geofence service only if the positionstream is null with us
    if (_positionStream == null) {
      _geoFencestream = _controller.stream;
      _positionStream = Geolocator.getPositionStream(
      ).listen((Position position) {
        _printOnConsole(position);
        _checkGeofence(position.latitude, position.longitude,eventPeriodInSeconds);
        _positionStream!
            .pause(Future.delayed(Duration(seconds: eventPeriodInSeconds!)));
      });
      _controller.add(GeofenceStatus.init);
    }
  }

  ///
  /// [_checkGeofence] is for checking whether current location is in
  /// or
  /// outside of the geofence area
  /// this takes two parameters which is [double] distanceInMeters
  /// distanceInMeters parameters is basically the calculated distance between
  /// geofence area points and the current location points
  /// radiusInMeter take value in [double] and it's the radius of geofence area in meters
  ///
  static _checkGeofence(double latitude, double longitude,int? eventPeriodInSeconds) {

    List<LatLng> poly = <LatLng>[
      const LatLng(22.288844592906457, 73.36365257319257),
      const LatLng(22.288832183886324, 73.36377796646488),
      const LatLng(22.288708093624617, 73.36377863701715),
      const LatLng(22.28870499136666, 73.3637357216726),
      const LatLng(22.288651012067227, 73.36372700449324),
      const LatLng(22.288732911685784, 73.36363782104289),
    ];
    bool cl =  PolyUtils.containsLocation(latitude,longitude,poly);
    if(cl){
      _controller.add(GeofenceStatus.enter);
      User.count = User.count+eventPeriodInSeconds!;
      User.sec = User.sec+eventPeriodInSeconds;
      if(User.sec>=60){
        User.min = User.min+1;
        User.sec = User.sec-60;
        if(User.min>=60){
          User.hr = User.hr+1;
          User.min = User.min-60;
        }
      }
      if(User.hr>=5){
        User.att = "PRESENT";
      }
    }
    else{
      _controller.add(GeofenceStatus.exit);
    }
  }
  ///
  /// [stopGeofenceService] to stop the geofencing service
  /// if the [_positionStream] is not null then
  /// it will cancel the subscription of the stream
  ///
  static stopGeofenceService() {
    if (_positionStream != null) {
      _positionStream!.cancel();

    }
  }

  ///
  /// [_printOnConsole] to help end user for debugging the existing code
  ///
  static _printOnConsole(Position position) {
    print("Current Position ${position.toJson()}");
  }
}