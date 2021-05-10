import 'package:equatable/equatable.dart';

class Position extends Equatable{
  final double latitude;
  final double longitude;

  Position(this.latitude, this.longitude)
      : assert(latitude > -90 && latitude < 90, "latitude is not valid"),
        assert(longitude > -180 && longitude < 180, "longitude is not valid");

  @override
  String toString() {
    return "latitude: ${this.latitude} , longitude: ${this.longitude}";
  }

  @override
  List<Object?> get props => [latitude, longitude];
}
