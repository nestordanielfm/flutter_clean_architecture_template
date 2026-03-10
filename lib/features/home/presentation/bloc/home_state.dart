import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final List<Pokemon>? pokemonList;
  final Failure? failure;
  final bool hasReachedMax;
  final int currentOffset;

  const HomeState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pokemonList,
    this.failure,
    this.hasReachedMax = false,
    this.currentOffset = 0,
  });

  // Helper getters
  bool get isSuccess => pokemonList != null && pokemonList!.isNotEmpty;
  bool get isError => failure != null;
  bool get isInitial => !isLoading && pokemonList == null && failure == null;

  // copyWith for state updates
  HomeState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<Pokemon>? pokemonList,
    Failure? failure,
    bool? hasReachedMax,
    int? currentOffset,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pokemonList: pokemonList ?? this.pokemonList,
      failure: failure ?? this.failure,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentOffset: currentOffset ?? this.currentOffset,
    );
  }

  // Helper methods
  HomeState toLoading() => HomeState(
    isLoading: true,
    isLoadingMore: false,
    pokemonList: pokemonList,
    failure: null,
    hasReachedMax: hasReachedMax,
    currentOffset: currentOffset,
  );

  HomeState toLoadingMore() => HomeState(
    isLoading: false,
    isLoadingMore: true,
    pokemonList: pokemonList,
    failure: null,
    hasReachedMax: hasReachedMax,
    currentOffset: currentOffset,
  );

  HomeState toSuccess(List<Pokemon> pokemonList) => HomeState(
    isLoading: false,
    isLoadingMore: false,
    pokemonList: pokemonList,
    failure: null,
    hasReachedMax: false,
    currentOffset: pokemonList.length,
  );

  HomeState toSuccessMore(List<Pokemon> newPokemon) {
    final updatedList = List<Pokemon>.from(pokemonList ?? [])
      ..addAll(newPokemon);
    return HomeState(
      isLoading: false,
      isLoadingMore: false,
      pokemonList: updatedList,
      failure: null,
      hasReachedMax: newPokemon.isEmpty,
      currentOffset: updatedList.length,
    );
  }

  HomeState toError(Failure failure) => HomeState(
    isLoading: false,
    isLoadingMore: false,
    pokemonList: pokemonList,
    failure: failure,
    hasReachedMax: hasReachedMax,
    currentOffset: currentOffset,
  );

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    pokemonList,
    failure,
    hasReachedMax,
    currentOffset,
  ];
}
