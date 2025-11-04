import 'package:equatable/equatable.dart';

class PokemonDetail extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;

  const PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
  });

  @override
  List<Object> get props => [
    id,
    name,
    imageUrl,
    height,
    weight,
    types,
    abilities,
  ];
}
