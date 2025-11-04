import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final List<Pokemon>? pokemonList;
  final Failure? failure;

  const HomeState({this.isLoading = false, this.pokemonList, this.failure});

  // Helper getters
  bool get isSuccess => pokemonList != null;
  bool get isError => failure != null;
  bool get isInitial => !isLoading && pokemonList == null && failure == null;

  // copyWith for state updates
  HomeState copyWith({
    bool? isLoading,
    List<Pokemon>? pokemonList,
    Failure? failure,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      pokemonList: pokemonList ?? this.pokemonList,
      failure: failure ?? this.failure,
    );
  }

  // Helper methods
  HomeState toLoading() => copyWith(isLoading: true, failure: null);
  HomeState toSuccess(List<Pokemon> pokemonList) =>
      copyWith(isLoading: false, pokemonList: pokemonList, failure: null);
  HomeState toError(Failure failure) =>
      copyWith(isLoading: false, failure: failure);

  @override
  List<Object?> get props => [isLoading, pokemonList, failure];
}
