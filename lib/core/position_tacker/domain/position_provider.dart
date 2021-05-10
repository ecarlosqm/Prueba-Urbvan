import 'package:urbvan/core/shared/domain/position.dart';
import 'package:urbvan/core/shared/domain/response.dart';

abstract class PositionProvider {
  Future<Response<Position>> getPosition();
}