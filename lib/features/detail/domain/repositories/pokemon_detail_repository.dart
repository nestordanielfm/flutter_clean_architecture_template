import 'package:dartz/dartz.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';

abstract class PokemonDetailRepository {
  Future<Either<Failure, PokemonDetail>> getPokemonDetail(int id);
}
