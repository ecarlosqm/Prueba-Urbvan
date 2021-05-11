import 'package:equatable/equatable.dart';
import 'package:urbvan/core/shared/domain/position.dart';

class Path extends Equatable {
  final List<Position> polyline;
  final PathBounds bounds;
  final String distance;
  final String duration;

  Path({
    required this.polyline,
    required this.bounds,
    required this.distance,
    required this.duration,
  });

  bool get isNull => false;

  @override
  List<Object?> get props => [polyline];
}

class PathBounds {
  final Position northeast;
  final Position southwest;

  PathBounds(this.northeast, this.southwest);
}

class NullPath extends Path {
  NullPath()
      : super(
          polyline: [],
          bounds: PathBounds(Position(0, 0), Position(0, 0)),
          distance: "",
          duration: "",
        );

  @override
  bool get isNull => true;
}
