import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan/ui/controllers/position_tracker_controller.dart';
import 'package:urbvan/ui/utils/utils.dart';

class PositionTackerPage extends StatefulWidget {
  @override
  _PositionTackerPageState createState() => _PositionTackerPageState();
}

class _PositionTackerPageState extends State<PositionTackerPage> {
  @override
  void initState() {
    context.read<PositionTrackerController>().startTracking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PositionTrackerController, PositionTrackerState>(
      listener: (context, state) {
        if (state.hasError) showConfirmationDialog(context, "Error", "${state.errorMessage!} . ¿Quieres intentarlo de nuevo?", context.read<PositionTrackerController>().retry);
      },
      builder: (context, state) => Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: (CameraPosition(
              target: LatLng(0, 0),
              zoom: 5,
            )),
            onMapCreated: (GoogleMapController controller) {
              context
                  .read<PositionTrackerController>()
                  .setGoogleMapsController(controller);
            },
            markers: {state.marker},
          ),
          if (state.hasError)
            ElevatedButton.icon(
              icon: Icon(Icons.refresh),
              onPressed: context.read<PositionTrackerController>().retry,
              label: Text("Intentar de nuevo"),
            ),
        ],
      ),
    );
  }
}
