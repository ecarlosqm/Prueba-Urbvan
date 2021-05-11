import 'dart:async';

import 'package:urbvan/core/position_tacker/domain/position_provider.dart';
import 'package:urbvan/core/shared/domain/position.dart';

class PositionTraker {
  late StreamController<Position> _streamController;
  late Duration _intervals;
  late PositionProvider _positionPorvider;
  late int _attempts;
  bool _iHaveFailed = false;
  Timer? _timer;

  PositionTraker(PositionProvider positionProvider, Duration intervals,
      [int attempts = 4]) {
    _streamController = StreamController<Position>.broadcast();
    _positionPorvider = positionProvider;
    _intervals = intervals;
    _attempts = attempts;
  }

  void _fireRequest( int attempt) async {
    if (attempt > _attempts) {
      _cancelIntervals();
      return _streamController.addError("No fue posible obtener la ubicación");
    }
    try {
      final response = await _positionPorvider.getPosition();
      if (response.success) {
        if (_iHaveFailed) {
          _iHaveFailed = false;
          _initIntervals();
        }
        return _streamController.add(response.value!);
      } else {
        _iHaveFailed = true;
        _cancelIntervals();
        _fireRequest( ++attempt);
      }
    } catch (e) {
      _iHaveFailed = true;
      _cancelIntervals();
      _fireRequest( ++attempt);
    }
  }

  Stream<Position> positions() {
    _fireRequest(1);
    _initIntervals();
    return _streamController.stream;
  }

  void _initIntervals() {
    _timer?.cancel();
    _timer = Timer.periodic(_intervals, (timer) => _fireRequest(1));
  }

  void _cancelIntervals() {
    _timer?.cancel();
  }

  Future<void> dispose() async {
    _timer?.cancel();
    _streamController.close();
  }
}
