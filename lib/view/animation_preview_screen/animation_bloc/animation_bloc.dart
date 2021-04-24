import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/drawing.dart';
import '../../../domain/entities/sketch.dart';
import '../../../domain/repositories/drawings_repository.dart';
import '../widgets/animation_preview_controller.dart';

part 'animation_event.dart';
part 'animation_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  AnimationPreviewController _animationPreviewController =
      AnimationPreviewController(
    [],
  );

  late StreamSubscription _streamSubscription;

  final DrawingsRepository _drawingsRepository;
  AnimationBloc(this._drawingsRepository)
      : super(
            AnimationInitial(Drawing(canvasPaths: [], sketchId: '', id: ''))) {
    _streamSubscription =
        _animationPreviewController.generateFrameCall().listen((drawing) {
      this.add(ChangeFrame(drawing));
    });
  }

  @override
  Stream<AnimationState> mapEventToState(
    AnimationEvent event,
  ) async* {
    if (event is ScreenStarted) {
      _animationPreviewController.setSkecth(_drawingsRepository.currentSketch);
    } else if (event is ChangeFrame) {
      yield DrawingPresented(event.drawing);
    } else if (event is ChangeFps) {
      await _streamSubscription.cancel();
      _animationPreviewController.setFrameDuration(
          Duration(milliseconds: ((1 / event.fps) * 1000).toInt()));
      _streamSubscription =
          _animationPreviewController.generateFrameCall().listen((drawing) {
        this.add(ChangeFrame(drawing));
      });
    }
  }
}
