import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan/core/route_generator/domain/path.dart';
import 'package:urbvan/core/route_generator/domain/route.dart';
import 'package:urbvan/core/route_generator/route_generator.dart';
import 'package:urbvan/core/shared/domain/position.dart';
import 'package:urbvan/ui/utils/extensions/extensions.dart';

class RouteGeneratorController extends Cubit<RouteGeneratorState> {
  final RouteGenerator routeGenerator;
  RouteGeneratorController(this.routeGenerator)
      : super(RouteGeneratorState.initialSate);

  void addPosition(LatLng latLng) async {
    emit(state.loadingState);
    try {
      final route = await routeGenerator.addPosition(
        state.route,
        Position(latLng.latitude, latLng.longitude),
      );
      emit(
        RouteGeneratorState(
          controller: state.controller,
          isLoading: false,
          route: route,
        ),
      );
      await animateBounds(route.lastNode?.getBoundsForGoogleMaps);
    } catch (e) {
      emit(
        state.errorState("No fue posible obtener la ruta"),
      );
    }
  }

  Future<void> animateBounds(LatLngBounds? bounds) async {
    if (bounds != null) {
      state.controller?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    }
  }

  void clear() async {
    emit(state.changeRoute(state.route..clear()));
  }

  void pop() async {
    emit(state.changeRoute(state.route..pop()));
  }

  void changePathOfLastNode(Path path) async {
    emit(state.changeRoute(state.route..changeSelectedPath(path)));
    animateBounds(state.route.lastNode?.getBoundsForGoogleMaps);
  }

  void setGoogleMapsController(GoogleMapController controller) async {
    emit(state.setController(controller));
    emit(state.completeState);
  }
}

class RouteGeneratorState {
  final GoogleMapController? controller;
  final bool isLoading;
  final Route route;
  final String? errorMessage;

  RouteGeneratorState({
    required this.controller,
    required this.isLoading,
    required this.route,
    this.errorMessage,
  });

  bool get hasError => errorMessage != null;

  Set<Marker> get markers {
    final markers = route.lastNode
        ?.map(
          (routeNode) => Marker(
              markerId: MarkerId(
                routeNode.hashCode.toString(),
              ),
              position: routeNode.position.getLatLngForGoogleMaps),
        )
        .toSet();
    return markers ?? {};
  }

  Set<Polyline> get polilines {
    final polyline = route.lastNode?.map(
      (routePoint) {
        final polyline = Polyline(
          polylineId: PolylineId(
            routePoint.hashCode.toString(),
          ),
          color: Color(
            routePoint.color,
          ),
          width: 5,
          points: routePoint.selectedPath.polyline
              .map((position) => position.getLatLngForGoogleMaps)
              .toList(),
        );
        return polyline;
      },
    ).toSet();
    return polyline ?? {};
  }

  static RouteGeneratorState get initialSate =>
      RouteGeneratorState(controller: null, isLoading: true, route: Route());
  RouteGeneratorState changeRoute(Route route) => RouteGeneratorState(
      controller: controller, isLoading: isLoading, route: route);
  RouteGeneratorState get loadingState =>
      RouteGeneratorState(controller: controller, isLoading: true, route: route);
  RouteGeneratorState get completeState =>
      RouteGeneratorState(controller: controller, isLoading: false, route: route);
  RouteGeneratorState errorState(String error) => RouteGeneratorState(
        controller: controller,
        isLoading: isLoading,
        route: route,
        errorMessage: error,
      );

  RouteGeneratorState setController(GoogleMapController controller) =>
      RouteGeneratorState(
        controller: controller,
        isLoading: isLoading,
        route: route,
      );
}
