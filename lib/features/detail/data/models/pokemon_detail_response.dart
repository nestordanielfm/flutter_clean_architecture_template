import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';

part 'pokemon_detail_response.g.dart';

@JsonSerializable()
class PokemonDetailResponse {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<TypeSlot> types;
  final List<AbilitySlot> abilities;
  final Sprites sprites;

  PokemonDetailResponse({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.sprites,
  });

  factory PokemonDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonDetailResponseToJson(this);

  PokemonDetail toEntity() {
    return PokemonDetail(
      id: id,
      name: name,
      imageUrl: sprites.frontDefault ?? '',
      height: height,
      weight: weight,
      types: types.map((t) => t.type.name).toList(),
      abilities: abilities.map((a) => a.ability.name).toList(),
    );
  }
}

@JsonSerializable()
class TypeSlot {
  final int slot;
  final NamedResource type;

  TypeSlot({required this.slot, required this.type});

  factory TypeSlot.fromJson(Map<String, dynamic> json) =>
      _$TypeSlotFromJson(json);

  Map<String, dynamic> toJson() => _$TypeSlotToJson(this);
}

@JsonSerializable()
class AbilitySlot {
  final int slot;
  final NamedResource ability;

  AbilitySlot({required this.slot, required this.ability});

  factory AbilitySlot.fromJson(Map<String, dynamic> json) =>
      _$AbilitySlotFromJson(json);

  Map<String, dynamic> toJson() => _$AbilitySlotToJson(this);
}

@JsonSerializable()
class NamedResource {
  final String name;
  final String url;

  NamedResource({required this.name, required this.url});

  factory NamedResource.fromJson(Map<String, dynamic> json) =>
      _$NamedResourceFromJson(json);

  Map<String, dynamic> toJson() => _$NamedResourceToJson(this);
}

@JsonSerializable()
class Sprites {
  @JsonKey(name: 'front_default')
  final String? frontDefault;

  Sprites({this.frontDefault});

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);

  Map<String, dynamic> toJson() => _$SpritesToJson(this);
}
