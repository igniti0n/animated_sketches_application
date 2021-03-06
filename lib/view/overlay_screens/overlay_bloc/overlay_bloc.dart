import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../domain/repositories/drawings_repository.dart';
import '../overlay_delete_drawing.dart';
import '../overlay_error.dart';
import '../../../domain/entities/sketch.dart';
import '../../../domain/repositories/sketches_repository.dart';
import '../overlay_color_picker.screen.dart';
import '../overlay_edit_sketch.dart';

part 'overlay_event.dart';
part 'overlay_state.dart';

class OverlayBloc extends Bloc<OverlayEvent, OverlayState> {
  final SketchesRepository _sketchesRepository;
  final DrawingsRepository _drawingsRepository;
  OverlayBloc(this._sketchesRepository, this._drawingsRepository)
      : super(OverlayInitial());

  @override
  Stream<OverlayState> mapEventToState(
    OverlayEvent event,
  ) async* {
    // log(event.toString());
    if (event is ShowEditOverlay) {
      showEditSketchOverlay(event.context, event.sketch);
      yield OverlayEditSketchStarted();
    } else if (event is ShowDeleteSketchOverlay) {
      showEditSketchOverlay(event.context, event.sketch);
      yield OverlayDeleteSketchStarted();
    } else if (event is ShowDeleteDrawingOverlay) {
      showDeleteDrawingDialog(event.context);
      yield OverlayDeleteSketchStarted();
    } else if (event is ExitOverlay) {
      Navigator.of(event.context).pop();
      yield OverlayInitial();
    } else if (event is ShowColorPicker) {
      showColorPicker(event.context, event.currentColor,
          isForBackground: event.isForBackground);
      yield OverlayColorPickerStarted();
    } else if (event is ShowErrorOverlay) {
      showErrorDialog(event.context, event.message);
      yield OverlayInitial();
    } else if (event is EditSketch) {
      yield OverlayLoading();
      final either = await _sketchesRepository.editSketch(event.name, event.id);
      yield either.fold((l) => OverlayError('Editing failed to complete.'),
          (r) => OverlaySuccess('Editing completed successfully!'));
    } else if (event is DeleteSketch) {
      yield OverlayLoading();
      final either = await _sketchesRepository.deleteSketch(event.sketchId);

      yield either.fold((l) => OverlayError('Deleting sketch failed.'),
          (r) => OverlaySuccess('Deleting completed successfully!'));
    } else if (event is DeleteDrawing) {
      yield OverlayLoading();
      final either = await _drawingsRepository.deleteDrawing();
      yield either.fold((l) => OverlayError('Deleting drawing failed.'),
          (r) => OverlaySuccess('Deleting completed successfully!'));
    }
  }
}
