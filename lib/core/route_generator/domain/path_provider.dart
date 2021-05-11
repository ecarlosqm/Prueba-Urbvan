import 'package:urbvan/core/route_generator/domain/path.dart';
import 'package:urbvan/core/shared/domain/position.dart';
import 'package:urbvan/core/shared/domain/response.dart';

abstract class PathProvider {
  Future<Response<List<Path>>> getPaths({required Position from, required  Position to,});
}
