import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:urbvan/ui/widgets/floating_option.dart';

class FloatingOptions extends StatefulWidget {
  final double buttonHeight;
  final double maxHeight;
  final double maxWidth;
  final Widget child;
  final String title;
  final bool show;
  final List<FloatingOptionWidget> options;
  const FloatingOptions({
    Key? key,
    required this.buttonHeight,
    required this.maxHeight,
    required this.child,
    required this.maxWidth,
    required this.options,
    required this.title,
    required this.show,
  }) : super(key: key);

  @override
  _FloatingOptionsState createState() => _FloatingOptionsState();
}

class _FloatingOptionsState extends State<FloatingOptions>
    with SingleTickerProviderStateMixin {
  late final AnimationController _navbarAnimcationController;
  bool _expanded = false;
  late double _currentHeight;

  Widget _buildOptions() {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            GestureDetector(
              onTap: _expanded ? close : open,
              child: Container(
                width: double.infinity,
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: widget.maxWidth - widget.buttonHeight,
                width: widget.maxWidth,
                child: ListView(
                  children: widget.options,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        widget.child,
        if(widget.show) GestureDetector(
          onVerticalDragUpdate: _onVerticalDrag,
          onVerticalDragEnd: _onVerticalDragStops,
          child: AnimatedBuilder(
            animation: _navbarAnimcationController,
            builder: (context, snapshot) {
              final value = _navbarAnimcationController.value;
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    bottom: lerpDouble(20, 20, value),
                    width: widget.maxWidth,
                    height: lerpDouble(
                        widget.buttonHeight, widget.maxHeight, value),
                    child: _buildOptions(),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    _currentHeight = widget.buttonHeight;
    _navbarAnimcationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    super.initState();
  }

  @override
  void dispose() {
    _navbarAnimcationController.dispose();
    super.dispose();
  }

  void close() async {
    await _navbarAnimcationController.reverse(
        from: _currentHeight / widget.maxHeight);
    _currentHeight = widget.buttonHeight;
    _expanded = false;
  }

  void open() async {
    setState(() {
      _expanded = true;
    });
    await _navbarAnimcationController.forward(
        from: _currentHeight / widget.maxHeight);
    _currentHeight = widget.maxHeight;
  }

  void _onVerticalDrag(DragUpdateDetails details) {
    setState(() {
      final newHeight = _currentHeight - details.delta.dy;
      _navbarAnimcationController.value = _currentHeight / widget.maxHeight;
      _currentHeight = newHeight.clamp(
        widget.buttonHeight,
        widget.maxHeight,
      );
    });
  }

  void _onVerticalDragStops(DragEndDetails details) {
    if (_expanded) {
      if (_currentHeight <= (widget.maxHeight / 8) * 7) {
        close();
      } else {
        open();
      }
    } else {
      if (_currentHeight <= widget.maxHeight / 3) {
        close();
      } else {
        open();
      }
    }
  }
}
