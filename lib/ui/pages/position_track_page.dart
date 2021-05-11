import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan/core/position_tacker/position_tracker.dart';
import 'package:urbvan/core/shared/domain/position.dart';
import 'package:urbvan/ui/utils/utils.dart';

class PositionTackerPage extends StatefulWidget {
  final PositionTraker positionTraker;

  const PositionTackerPage({Key? key, required this.positionTraker})
      : super(key: key);
  @override
  _PositionTackerPageState createState() => _PositionTackerPageState();
}

class _PositionTackerPageState extends State<PositionTackerPage> {
  Completer<GoogleMapController> _controller = Completer();
  Marker marker = Marker(markerId: MarkerId("ISS"));
  late StreamSubscription _subscription;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _subscription = widget.positionTraker
        .positions()
        .listen(_onNewPosition, onError: _onPositionError);
  }

  @override
  void dispose() {
    _subscription.cancel();
    widget.positionTraker.dispose();
    super.dispose();
  }

  void _onNewPosition(Position position) async {
    setState(() {
      marker = Marker(
          markerId: MarkerId("ISS"),
          position: LatLng(position.latitude, position.longitude));
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 5),
      ),
    );
  }

  void _onPositionError(Object error) {
    setState(() {
      this.error = true;
    });
    showConfirmationDialog(
        context, "Ocurrio un error", "Quieres volver a intentar", _retry);
  }

  void _retry() {
    setState(() {
      error = false;
    });
    _subscription.cancel();
    _subscription = widget.positionTraker
        .positions()
        .listen(_onNewPosition, onError: _onPositionError);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          mapType: MapType.terrain,
          initialCameraPosition: (CameraPosition(
            target: LatLng(0, 0),
            zoom: 5,
          )),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {marker},
        ),
        if (error)
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            onPressed: _retry, label: Text("Intentar de nuevo"),
          ),
      ],
    );
  }
}
