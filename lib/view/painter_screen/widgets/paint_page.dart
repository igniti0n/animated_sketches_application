import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/native/image_saver.dart';
import '../settings_bloc/settings_bloc.dart';
import 'app_painter.dart';
import '../drawing_bloc/drawing_bloc.dart';
import '../settings_picker.dart';

class PaintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;

    log(_deviceSize.width.toString());

    return Scaffold(
      body: SizedBox(
        height: _deviceSize.height,
        width: _deviceSize.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: _deviceSize.width / 8,
                maxHeight: _deviceSize.height,
              ),
              child: SettingsPicker(),
            ),
            Expanded(
              child: ClipPath(
                clipper: CanvasClipper(),
                child: PaintCanvas(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaintCanvas extends StatefulWidget {
  // final List<CanvasPath> initialdrawPoints;

  const PaintCanvas({
    Key? key,
    // this.initialdrawPoints = const [],
  }) : super(key: key);

  @override
  _PaintCanvasState createState() => _PaintCanvasState();
}

class _PaintCanvasState extends State<PaintCanvas> {
  Paint _currentPaintSettings = Paint()
    ..strokeWidth = 1
    ..color = Colors.black;

  void _addPoint(Offset newPoint) {
    BlocProvider.of<DrawingBloc>(context).add(UpdateDrawing(newPoint));
  }

  void _addLastPoint() {
    BlocProvider.of<DrawingBloc>(context).add(EndDrawing());
  }

  Paint _paintFrom(Paint paint) {
    return Paint()
      ..color = paint.color
      ..strokeWidth = paint.strokeWidth
      ..blendMode = paint.blendMode
      ..strokeCap = paint.strokeCap
      ..shader = paint.shader;
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _drawingBloc = BlocProvider.of<DrawingBloc>(context);

    return BlocBuilder<DrawingBloc, DrawingState>(
      builder: (context, state) {
        log(state.runtimeType.toString() +
            '    ' +
            state.currentDrawing.canvasPaths.length.toString());
        return RepaintBoundary(
          child: CustomPaint(
            key: globalKey,
            isComplex: true,
            willChange: true,
            foregroundPainter: AppPainter(
              drawing: state.currentDrawing,
            ),
            painter: AppPainter(
              drawing: state.previousDrawing,
              isForeground: false,
            ),
            child: BlocListener<SettingsBloc, SettingsState>(
              listener: (context, state) {
                _currentPaintSettings = state.paintSettings;
              },
              child: GestureDetector(
                onPanStart: (det) {
                  _drawingBloc.add(StartDrawing(
                    //TODO: state.paintSettings instead?
                    paint: _paintFrom(_currentPaintSettings),
                    offset: det.localPosition,
                  ));
                },
                onPanUpdate: (det) => _addPoint(
                  Offset(det.localPosition.dx, det.localPosition.dy),
                ),
                onPanEnd: (det) => _addLastPoint(),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: _size.height,
                    maxWidth: _size.width,
                  ),
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CanvasClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    final _path = Path();
    _path.moveTo(0, 0);
    _path.lineTo(size.width, 0);

    _path.lineTo(size.width, size.height);

    _path.lineTo(0, size.height);
    _path.close();
    return _path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
