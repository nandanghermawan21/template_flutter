// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:enerren/util/system.dart';
class GeolocatorUtil {
  static Future<Position> myLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled == true) {
        return await Geolocator.getCurrentPosition();
      } else {
        throw "please allow gps";
      }
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  static Future<Position> myLocation2() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled == true) {
        return await Geolocator.getPositionStream().first;
      } else {
        throw "please allow gps";
      }
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  static Future<Placemark> getLocation(double lat, double lon) {
    return placemarkFromCoordinates(lat, lon).then((onValue) {
      return onValue.first;
    }).catchError((onError) {
      throw "$onError";
    });
  }

  static Future<String> getAddress(double lat, double lon, {String? alt}) {
    return placemarkFromCoordinates(lat, lon).then((onValue) {
      return changeToAddress(onValue.first);
    }).catchError((onError) {
      return alt ?? System.data.strings!.invalidLocationOnAddress;
    });
  }

  static String changeToAddress(Placemark place) {
    return "${place.thoroughfare} ${place.subThoroughfare} ${place.subLocality} ${place.locality} ${place.subAdministrativeArea} ${place.administrativeArea} ${place.country} ${place.postalCode}";
  }
}
