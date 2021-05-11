import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan/core/position_tacker/position_tracker.dart';
import 'package:urbvan/core/shared/domain/position.dart';

class PositionTrackerController extends Cubit<PositionTrackerState> {
  final PositionTraker positionTraker;

  PositionTrackerController(this.positionTraker)
      : super(PositionTrackerState.initialSate);

  late StreamSubscription _subscription;

  init() async {
    _subscription = positionTraker.positions().listen(
          _onNewPosition,
          onError: _onPositionError,
        );
  }

  @override
  Future<void> close() async {
    _subscription.cancel();
    positionTraker.dispose();
    super.close();
  }

  void _onNewPosition(Position position) async {
    emit(state.changeMarke(Marker(
        markerId: MarkerId("ISS"),
        position: LatLng(position.latitude, position.longitude))));
    state.controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 5,
        ),
      ),
    );
  }

  void _onPositionError(Object error) {
    emit(state.errorState("Ocurrió un error"));
  }

  void startTracking(){
    positionTraker.starTracking();
  }

  void retry() {
    emit(state.clearErrorState);
    _subscription.cancel();
    _subscription = positionTraker
        .positions()
        .listen(_onNewPosition, onError: _onPositionError);
  }

  void setGoogleMapsController(GoogleMapController controller) async {
    emit(state.setController(controller));
    emit(state.completeState);
  }
}

class PositionTrackerState {
  final GoogleMapController? controller;
  final Marker marker;
  final String? errorMessage;
  final bool isLoading;

  PositionTrackerState({
    required this.controller,
    required this.isLoading,
    required this.marker,
    this.errorMessage,
  });

  bool get hasError => errorMessage != null;

  static PositionTrackerState get initialSate => PositionTrackerState(
      controller: null,
      isLoading: true,
      marker: Marker(markerId: MarkerId("ISS")));
  PositionTrackerState changeMarke(Marker marker) => PositionTrackerState(
      controller: controller, isLoading: isLoading, marker: marker);
  PositionTrackerState get loadingState => PositionTrackerState(
      controller: controller, isLoading: true, marker: marker);
  PositionTrackerState get completeState => PositionTrackerState(
      controller: controller, isLoading: false, marker: marker);
  PositionTrackerState get clearErrorState => PositionTrackerState(
      controller: controller, isLoading: false, marker: marker);
  PositionTrackerState errorState(String error) => PositionTrackerState(
        controller: controller,
        isLoading: isLoading,
        marker: marker,
        errorMessage: error,
      );

  PositionTrackerState setController(GoogleMapController controller) =>
      PositionTrackerState(
        controller: controller,
        isLoading: isLoading,
        marker: marker,
      );
}
