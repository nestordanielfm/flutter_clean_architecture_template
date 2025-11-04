import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/features/detail/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_event.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetPokemonDetailUseCase getPokemonDetailUseCase;

  DetailBloc(this.getPokemonDetailUseCase) : super(const DetailState()) {
    on<LoadPokemonDetail>(_onLoadPokemonDetail);
  }

  Future<void> _onLoadPokemonDetail(
    LoadPokemonDetail event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.toLoading());

    final result = await getPokemonDetailUseCase(
      PokemonDetailParams(id: event.pokemonId),
    );

    result.fold(
      (failure) => emit(state.toError(failure)),
      (pokemonDetail) => emit(state.toSuccess(pokemonDetail)),
    );
  }
}
