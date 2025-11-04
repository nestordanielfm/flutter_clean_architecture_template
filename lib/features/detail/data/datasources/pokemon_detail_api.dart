import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:template_app/features/detail/data/models/pokemon_detail_response.dart';

part 'pokemon_detail_api.g.dart';

@RestApi(baseUrl: 'https://pokeapi.co/api/v2')
abstract class PokemonDetailApi {
  factory PokemonDetailApi(Dio dio, {String? baseUrl}) = _PokemonDetailApi;

  @GET('/pokemon/{id}')
  Future<PokemonDetailResponse> getPokemonDetail(@Path('id') int id);
}
