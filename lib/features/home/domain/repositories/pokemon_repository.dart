import 'package:dartz/dartz.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  });
}
