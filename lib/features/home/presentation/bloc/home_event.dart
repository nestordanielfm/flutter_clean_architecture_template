import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadPokemonList extends HomeEvent {
  const LoadPokemonList();
}

class LoadMorePokemon extends HomeEvent {
  const LoadMorePokemon();
}

class LogoutRequested extends HomeEvent {
  const LogoutRequested();
}
