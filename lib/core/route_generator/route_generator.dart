import 'package:urbvan/core/route_generator/domain/path.dart';
import 'package:urbvan/core/route_generator/domain/path_provider.dart';
import 'package:urbvan/core/route_generator/domain/route.dart';
import 'package:urbvan/core/route_generator/domain/route_node_description.dart';
import 'package:urbvan/core/shared/domain/position.dart';
import 'package:urbvan/core/route_generator/domain/route_node.dart';

class RouteGenerator {
  final PathProvider _pathGenerator;

  RouteGenerator(this._pathGenerator);

  List colors = [
    0xFF4CAF50,
    0xFF2196F3,
    0xFFE91E63,
    0xFF9C27B0,
    0xFFF44336,
    0xFF009688
  ];

  int nextColor = 0;

  int getNextColor() {
    nextColor = (nextColor + 1) % colors.length;
    return colors[nextColor];
  }

  Future<Route> generate(List<Position> positions) async {
    assert(
      positions.length < 1,
      "Para genera una ruta debes proporcionar al menos una posicion",
    );
    RouteNode result = RouteNode(
      routeNodeDescription: RouteNodeDescription(
        position: positions.first,
        selectedPath: NullPath(),
        paths: [],
        color: getNextColor(),
      ),
    );
    for (var i = 1; i < positions.length; i++) {
      final pathResponse = await _pathGenerator.getPaths(
        from: result.position,
        to: positions[i],
      );
      result = RouteNode(
        next: result,
        routeNodeDescription: RouteNodeDescription(
          position: positions.first,
          selectedPath: pathResponse.value!.first,
          paths: pathResponse.value!,
          color: getNextColor(),
        ),
      );
    }
    return Route(result);
  }

  Future<Route> addPosition(Route route, Position position) async {
    if (route.last == null) {
      return Route(
        RouteNode(
          routeNodeDescription: RouteNodeDescription(
            position: position,
            selectedPath: NullPath(),
            paths: [],
            color: getNextColor(),
          ),
        ),
      );
    } else {
      final pathResponse = await _pathGenerator.getPaths(
        from: route.last!.position,
        to: position,
      );
      return Route(
        RouteNode(
          next: route.last,
          routeNodeDescription: RouteNodeDescription(
            position: position,
            selectedPath: pathResponse.value!.first,
            paths: pathResponse.value!,
            color: getNextColor(),
          ),
        ),
      );
    }
  }
}
