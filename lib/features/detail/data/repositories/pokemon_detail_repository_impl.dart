import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/detail/data/datasources/pokemon_detail_api.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';
import 'package:template_app/features/detail/domain/repositories/pokemon_detail_repository.dart';

class PokemonDetailRepositoryImpl implements PokemonDetailRepository {
  final PokemonDetailApi pokemonDetailApi;

  PokemonDetailRepositoryImpl(this.pokemonDetailApi);

  @override
  Future<Either<Failure, PokemonDetail>> getPokemonDetail(int id) async {
    try {
      final response = await pokemonDetailApi.getPokemonDetail(id);
      return Right(response.toEntity());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure('Connection timeout'));
      }
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure('Pokémon not found'));
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
