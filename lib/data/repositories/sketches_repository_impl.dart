import 'package:paint_app/domain/entities/sketch.dart';
import 'package:paint_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:paint_app/domain/repositories/sketches_repository.dart';

class SketchesRepositoryImpl extends SketchesRepository {
  List<Sketch> _userSketches = [];

  @override
  Either<Failure, Sketch> getSketch(String id) {
    try {
      return Right(
          _userSketches.firstWhere((Sketch sketch) => sketch.id == id));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteSketch(String id) async {
    try {
      //TODO: delete data in db
      return Future.microtask(() => Right(null));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, List<Sketch>>> getSketches() async {
    try {
      return Future.microtask(() => Right(_userSketches));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }

  @override
  Future<Either<Failure, List<Sketch>>> addNewSketch(Sketch newSketch) async {
    try {
      return Future.microtask(() => Right(_userSketches));
    } catch (error) {
      return Left(SketchNotFoundFailure());
    }
  }
}