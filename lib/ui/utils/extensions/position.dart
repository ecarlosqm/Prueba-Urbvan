import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan/core/shared/domain/position.dart';

extension PositionExtension on Position {
  LatLng get getLatLngForGoogleMaps {
    return LatLng(this.latitude, this.longitude);
  }
}