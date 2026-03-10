import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';
import 'package:template_app/features/home/domain/repositories/pokemon_repository.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class GetPokemonListUseCase
    implements UseCase<List<Pokemon>, PokemonListParams> {
  final PokemonRepository repository;

  GetPokemonListUseCase(this.repository);

  @override
  Future<Either<Failure, List<Pokemon>>> call(PokemonListParams params) async {
    return await repository.getPokemonList(
      limit: params.limit,
      offset: params.offset,
    );
  }
}

class PokemonListParams extends Equatable {
  final int limit;
  final int offset;

  const PokemonListParams({this.limit = 20, this.offset = 0});

  @override
  List<Object> get props => [limit, offset];
}
