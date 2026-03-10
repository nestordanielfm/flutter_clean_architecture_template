import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:template_app/features/home/presentation/bloc/home_event.dart';
import 'package:template_app/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPokemonListUseCase getPokemonListUseCase;
  static const int _pokemonLimit = 20;

  HomeBloc(this.getPokemonListUseCase) : super(const HomeState()) {
    on<LoadPokemonList>(_onLoadPokemonList);
    on<LoadMorePokemon>(_onLoadMorePokemon);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadPokemonList(
    LoadPokemonList event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.toLoading());

    final result = await getPokemonListUseCase(
      const PokemonListParams(limit: _pokemonLimit, offset: 0),
    );

    result.fold(
      (failure) => emit(state.toError(failure)),
      (pokemonList) => emit(state.toSuccess(pokemonList)),
    );
  }

  Future<void> _onLoadMorePokemon(
    LoadMorePokemon event,
    Emitter<HomeState> emit,
  ) async {
    // Don't load if already loading or reached max
    if (state.isLoadingMore || state.hasReachedMax) return;

    emit(state.toLoadingMore());

    final result = await getPokemonListUseCase(
      PokemonListParams(limit: _pokemonLimit, offset: state.currentOffset),
    );

    result.fold(
      (failure) => emit(state.toError(failure)),
      (pokemonList) => emit(state.toSuccessMore(pokemonList)),
    );
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<HomeState> emit) {
    // Handle logout logic here
    emit(const HomeState());
  }
}
