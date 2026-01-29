import 'package:mobx/mobx.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';
import 'package:template_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final GetPokemonListUseCase getPokemonListUseCase;

  _HomeStore(this.getPokemonListUseCase);

  @observable
  bool isLoading = false;

  @observable
  List<Pokemon>? pokemonList;

  @observable
  Failure? failure;

  @computed
  bool get isSuccess => pokemonList != null;

  @computed
  bool get isError => failure != null;

  @computed
  bool get isInitial => !isLoading && pokemonList == null && failure == null;

  @action
  Future<void> loadPokemonList() async {
    isLoading = true;
    failure = null;

    final result = await getPokemonListUseCase(const PokemonListParams());

    result.fold(
      (fail) {
        failure = fail;
        isLoading = false;
      },
      (list) {
        pokemonList = list;
        isLoading = false;
      },
    );
  }

  @action
  void reset() {
    isLoading = false;
    pokemonList = null;
    failure = null;
  }
}
