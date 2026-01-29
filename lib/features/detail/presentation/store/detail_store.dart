import 'package:mobx/mobx.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';
import 'package:template_app/features/detail/domain/usecases/get_pokemon_detail_usecase.dart';

part 'detail_store.g.dart';

class DetailStore = _DetailStore with _$DetailStore;

abstract class _DetailStore with Store {
  final GetPokemonDetailUseCase getPokemonDetailUseCase;

  _DetailStore(this.getPokemonDetailUseCase);

  @observable
  bool isLoading = false;

  @observable
  PokemonDetail? pokemonDetail;

  @observable
  Failure? failure;

  @computed
  bool get isSuccess => pokemonDetail != null;

  @computed
  bool get isError => failure != null;

  @computed
  bool get isInitial => !isLoading && pokemonDetail == null && failure == null;

  @action
  Future<void> loadPokemonDetail(int pokemonId) async {
    isLoading = true;
    failure = null;

    final result = await getPokemonDetailUseCase(
      PokemonDetailParams(id: pokemonId),
    );

    result.fold(
      (fail) {
        failure = fail;
        isLoading = false;
      },
      (detail) {
        pokemonDetail = detail;
        isLoading = false;
      },
    );
  }

  @action
  void reset() {
    isLoading = false;
    pokemonDetail = null;
    failure = null;
  }
}
