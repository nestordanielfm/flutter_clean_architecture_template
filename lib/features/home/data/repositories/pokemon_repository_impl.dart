import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/home/data/datasources/pokemon_api.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';
import 'package:template_app/features/home/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonApi pokemonApi;

  PokemonRepositoryImpl(this.pokemonApi);

  @override
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    int limit = 20,
  }) async {
    try {
      final response = await pokemonApi.getPokemonList(limit);
      final pokemonList = response.results
          .map((item) => item.toEntity())
          .toList();
      return Right(pokemonList);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure('Connection timeout'));
      }
      if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
        return const Left(ServerFailure('Server error'));
      }
      return Left(ServerFailure(e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
