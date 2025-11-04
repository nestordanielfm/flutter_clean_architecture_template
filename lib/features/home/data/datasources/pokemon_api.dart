import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:template_app/features/home/data/models/pokemon_response.dart';

part 'pokemon_api.g.dart';

@RestApi(baseUrl: 'https://pokeapi.co/api/v2')
abstract class PokemonApi {
  factory PokemonApi(Dio dio, {String? baseUrl}) = _PokemonApi;

  @GET('/pokemon')
  Future<PokemonListResponse> getPokemonList(@Query('limit') int limit);
}
