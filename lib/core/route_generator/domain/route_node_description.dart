import 'package:equatable/equatable.dart';
import 'package:urbvan/core/route_generator/domain/path.dart';
import 'package:urbvan/core/shared/domain/position.dart';

class RouteNodeDescription extends Equatable {
  final Position position;
  final List<Path> paths;
  final Path selectedPath;
  final int color;

  RouteNodeDescription({
    required this.position,
    required this.selectedPath,
    required this.paths,
    required this.color,
  });

  Path getPathWithIndex(int index) {
    return paths[index];
  }

  RouteNodeDescription changePaths(List<Path> paths) {
    return _copyWith(paths: paths);
  }

  RouteNodeDescription changeSelected(Path path) {
    return _copyWith(selectedPath: path);
  }

  bool get hasAlternatives => paths.length > 1;

  RouteNodeDescription _copyWith({
    Position? position,
    List<Path>? paths,
    Path? selectedPath,
    int? color,
  }) {
    return RouteNodeDescription(
      position: position ?? this.position,
      selectedPath: selectedPath ?? this.selectedPath,
      paths: paths ?? this.paths,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [position, paths, color];
}
