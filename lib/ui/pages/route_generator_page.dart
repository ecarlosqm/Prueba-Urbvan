import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan/ui/controllers/route_generator_controller.dart';
import 'package:urbvan/ui/utils/widgets.dart';
import 'package:urbvan/ui/widgets/floating_option.dart';
import 'package:urbvan/ui/widgets/floating_options.dart';

class RouteGeneratorPage extends StatelessWidget {
  List<FloatingOptionWidget> getAternativeRoutesWidgets(
      RouteGeneratorController controller, RouteGeneratorState state) {
    return state.route.lastNode?.paths
            .map(
              (path) => FloatingOptionWidget(
                value: path,
                selected: state.route.lastNode?.selectedPath == path,
                title: "Alternativa de ${path.distance}",
                onSelect: (value) async {
                  controller.changePathOfLastNode(
                    path,
                  );
                },
              ),
            )
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RouteGeneratorController, RouteGeneratorState>(
      listener: (context, state) {
        if (state.hasError) showMessage(context, "Error", state.errorMessage!);
      },
      builder: (context, state) => FloatingOptions(
        title: "Rutas alternativas",
        show: state.route.lastNode?.hasAlternatives ?? false,
        buttonHeight: 50,
        maxHeight: MediaQuery.of(context).size.height * .3,
        maxWidth: MediaQuery.of(context).size.width * .8,
        options: state.route.lastNode?.hasAlternatives ?? false
            ? getAternativeRoutesWidgets(
                context.read<RouteGeneratorController>(), state)
            : [],
        child: Stack(
          children: [
            Container(
              height: double.infinity,
            ),
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: (CameraPosition(
                target: LatLng(19.422708, -99.133349),
                zoom: 15,
              )),
              onMapCreated: (GoogleMapController controller) {
                context
                    .read<RouteGeneratorController>()
                    .setGoogleMapsController(controller);
              },
              onLongPress: context.read<RouteGeneratorController>().addPosition,
              markers: state.markers,
              polylines: state.polilines,
            ),
            if (state.route.isNotEmty)
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.undo),
                        iconSize: 30,
                        onPressed: context.read<RouteGeneratorController>().pop,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        iconSize: 30,
                        onPressed:
                            context.read<RouteGeneratorController>().clear,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (state.isLoading)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
