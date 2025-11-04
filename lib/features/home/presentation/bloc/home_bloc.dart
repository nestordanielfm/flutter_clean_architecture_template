import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:template_app/features/home/presentation/bloc/home_event.dart';
import 'package:template_app/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPokemonListUseCase getPokemonListUseCase;

  HomeBloc(this.getPokemonListUseCase) : super(const HomeState()) {
    on<LoadPokemonList>(_onLoadPokemonList);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadPokemonList(
    LoadPokemonList event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.toLoading());

    final result = await getPokemonListUseCase(const PokemonListParams());

    result.fold(
      (failure) => emit(state.toError(failure)),
      (pokemonList) => emit(state.toSuccess(pokemonList)),
    );
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<HomeState> emit) {
    // Handle logout logic here
    emit(const HomeState());
  }
}
