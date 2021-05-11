import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan/ui/utils/extensions/extensions.dart';
import 'package:urbvan/core/route_generator/route_generator.dart';
import 'package:urbvan/core/route_generator/domain/route.dart'
    as routeGenerator;
import 'package:urbvan/core/shared/domain/position.dart';
import 'package:urbvan/ui/widgets/floating_option.dart';
import 'package:urbvan/ui/widgets/floating_options.dart';
import 'package:urbvan/ui/utils/utils.dart';

class RouteGeneratorPage extends StatefulWidget {
  final RouteGenerator routeGenerator;

  const RouteGeneratorPage({Key? key, required this.routeGenerator}) : super(key: key);
  @override
  _RouteGeneratorPageState createState() => _RouteGeneratorPageState();
}

class _RouteGeneratorPageState extends State<RouteGeneratorPage> {

  Completer<GoogleMapController> _controller = Completer();
  bool loading = false;
  routeGenerator.Route route = routeGenerator.Route();

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

  void _onLongPress(LatLng latLng) async {
    setState(() {
      loading = true;
    });
    try {
      final route = await widget.routeGenerator.addPosition(
        this.route,
        Position(latLng.latitude, latLng.longitude),
      );
      setState(() {
        this.route = route;
      });
      await animateBounds(route.lastNode?.getBoundsForGoogleMaps);
      setState(() {
        loading = false;
      });
    } catch (e) {
      showMessage(context, "Error", "No fue posible obtener la ruta");
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> animateBounds(LatLngBounds? bounds) async {
    if (bounds != null) {
      final controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    }
  }

  void _clear() async {
    route.clear();
    setState(() => null);
  }

  void _pop() async {
    route.pop();
    setState(() => null);
  }

  List<FloatingOptionWidget> getAternativeRoutesWidgets() {
    final alternatives = route.lastNode?.paths;
    return alternatives
            ?.map(
              (path) => FloatingOptionWidget(
                value: path,
                selected: route.lastNode?.selectedPath == path,
                title: "Alternativa de ${path.distance}",
                onSelect: (value) async {
                  route.changeSelectedPath(
                    path,
                  );
                  setState(() => null);
                  await animateBounds(route.lastNode?.getBoundsForGoogleMaps);
                },
              ),
            )
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return FloatingOptions(
      title: "Rutas alternativas",
      show: route.lastNode?.hasAlternatives ?? false,
      buttonHeight: 50,
      maxHeight: MediaQuery.of(context).size.height * .3,
      maxWidth: MediaQuery.of(context).size.width * .8,
      options: route.lastNode?.hasAlternatives ?? false
          ? getAternativeRoutesWidgets()
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
              _controller.complete(controller);
            },
            onLongPress: _onLongPress,
            markers: markers,
            polylines: polilines,
          ),
          if (route.isNotEmty)
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
                      onPressed: _pop,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: 30,
                      onPressed: _clear,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (loading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
