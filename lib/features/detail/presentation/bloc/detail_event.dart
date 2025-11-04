import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadPokemonDetail extends DetailEvent {
  final int pokemonId;

  const LoadPokemonDetail(this.pokemonId);

  @override
  List<Object?> get props => [pokemonId];
}
