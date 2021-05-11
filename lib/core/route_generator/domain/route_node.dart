import 'package:urbvan/core/route_generator/domain/path.dart';
import 'package:urbvan/core/route_generator/domain/route_node_description.dart';
import 'package:urbvan/core/shared/domain/position.dart';

typedef bool NodeTest(RouteNode node);
typedef T RouteMapper<T>(RouteNode node);
typedef Future<void> ForEachCallback(RouteNode node);

class RouteNode {
  RouteNodeDescription routeNodeDescription;
  RouteNode? next;

  RouteNode({
    required this.routeNodeDescription,
    this.next,
  });

  void changeSelectedPath(Path path) {
    routeNodeDescription = routeNodeDescription.changeSelected(path);
  }

  void changePaths(List<Path> paths) {
    routeNodeDescription = routeNodeDescription.changePaths(paths);
  }

  Position get position => routeNodeDescription.position;
  Path get selectedPath => routeNodeDescription.selectedPath;
  List<Path> get paths => routeNodeDescription.paths;
  int get color => routeNodeDescription.color;
  bool get hasAlternatives => routeNodeDescription.paths.length > 1;

  RouteNode? firstWhere(NodeTest predicate) {
    if (next == null) return predicate(this) ? this : null;
    return predicate(this) ? this : next!.firstWhere(predicate);
  }

  List<T> map<T>(RouteMapper<T> mapper) {
    if (next == null) return [mapper(this)];
    return [mapper(this), ...next!.map(mapper)];
  }

  Future<void> forEach<T>(ForEachCallback callback) async {
    if (next == null) {
      await callback(this);
      return;
    }
    await callback(this);
    await this.next!.forEach(callback);
  }
}
