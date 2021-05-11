import 'package:urbvan/core/route_generator/domain/route_node.dart';

class Route {
  RouteNode? _node;

  Route([this._node]);

  RouteNode? get last => _node;
  bool get isEmty => _node == null;
  bool get isNotEmty => _node != null;

  void pop() {
    _node = _node?.next;
  }

  void clear() {
    _node = null;
  }
}