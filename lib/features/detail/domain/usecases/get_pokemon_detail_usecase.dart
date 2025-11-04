import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';
import 'package:template_app/features/detail/domain/repositories/pokemon_detail_repository.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class GetPokemonDetailUseCase
    implements UseCase<PokemonDetail, PokemonDetailParams> {
  final PokemonDetailRepository repository;

  GetPokemonDetailUseCase(this.repository);

  @override
  Future<Either<Failure, PokemonDetail>> call(
    PokemonDetailParams params,
  ) async {
    return await repository.getPokemonDetail(params.id);
  }
}

class PokemonDetailParams extends Equatable {
  final int id;

  const PokemonDetailParams({required this.id});

  @override
  List<Object> get props => [id];
}
