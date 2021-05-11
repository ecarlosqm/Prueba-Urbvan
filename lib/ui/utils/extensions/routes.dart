import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan/core/route_generator/domain/route_node.dart';
import 'package:urbvan/ui/utils/extensions/extensions.dart';

extension RouteNodeExtencion on RouteNode {
  LatLngBounds? get getBoundsForGoogleMaps {
    if (this.routeNodeDescription.selectedPath.isNull) return null;
    final bound = this.routeNodeDescription.selectedPath.bounds;
    return LatLngBounds(
      northeast: bound.northeast.getLatLngForGoogleMaps,
      southwest: bound.southwest.getLatLngForGoogleMaps,
    );
  }
}