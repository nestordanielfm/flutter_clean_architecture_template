import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';

part 'pokemon_response.g.dart';

@JsonSerializable()
class PokemonListResponse {
  final int count;
  final List<PokemonItem> results;

  PokemonListResponse({required this.count, required this.results});

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonListResponseToJson(this);
}

@JsonSerializable()
class PokemonItem {
  final String name;
  final String url;

  PokemonItem({required this.name, required this.url});

  factory PokemonItem.fromJson(Map<String, dynamic> json) =>
      _$PokemonItemFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonItemToJson(this);

  Pokemon toEntity() {
    // Extract ID from URL (e.g., "https://pokeapi.co/api/v2/pokemon/1/")
    final id = int.parse(url.split('/').reversed.elementAt(1));
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

    return Pokemon(id: id, name: name, imageUrl: imageUrl);
  }
}
