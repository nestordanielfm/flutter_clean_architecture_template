import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';
import 'package:template_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:template_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:template_app/features/home/presentation/bloc/home_event.dart';
import 'package:template_app/features/home/presentation/bloc/home_state.dart';

class MockGetPokemonListUseCase extends Mock implements GetPokemonListUseCase {}

const tPokemonList = [
  Pokemon(
    id: 1,
    name: 'bulbasaur',
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
  ),
  Pokemon(
    id: 2,
    name: 'ivysaur',
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
  ),
];

const tMorePokemon = [
  Pokemon(
    id: 21,
    name: 'spearow',
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/21.png',
  ),
];

void main() {
  late HomeBloc homeBloc;
  late MockGetPokemonListUseCase mockGetPokemonListUseCase;

  setUp(() {
    mockGetPokemonListUseCase = MockGetPokemonListUseCase();
    homeBloc = HomeBloc(mockGetPokemonListUseCase);
  });

  setUpAll(() {
    registerFallbackValue(const PokemonListParams());
  });

  tearDown(() {
    homeBloc.close();
  });

  test('initial state should be HomeState with default values', () {
    expect(homeBloc.state, const HomeState());
    expect(homeBloc.state.isInitial, true);
  });

  blocTest<HomeBloc, HomeState>(
    'emits loading then success when LoadPokemonList succeeds',
    build: () {
      when(
        () => mockGetPokemonListUseCase(any()),
      ).thenAnswer((_) async => const Right(tPokemonList));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadPokemonList()),
    expect: () => [
      const HomeState(isLoading: true),
      const HomeState(
        isLoading: false,
        pokemonList: tPokemonList,
        currentOffset: 2,
      ),
    ],
    verify: (_) {
      verify(
        () => mockGetPokemonListUseCase(
          const PokemonListParams(limit: 20, offset: 0),
        ),
      ).called(1);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'emits loading then error when LoadPokemonList fails',
    build: () {
      when(
        () => mockGetPokemonListUseCase(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadPokemonList()),
    expect: () => [
      const HomeState(isLoading: true),
      const HomeState(isLoading: false, failure: ServerFailure('Server error')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits loading then error when LoadPokemonList fails with NetworkFailure',
    build: () {
      when(() => mockGetPokemonListUseCase(any())).thenAnswer(
        (_) async => const Left(NetworkFailure('Connection timeout')),
      );
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadPokemonList()),
    expect: () => [
      const HomeState(isLoading: true),
      const HomeState(
        isLoading: false,
        failure: NetworkFailure('Connection timeout'),
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits loadingMore then success when LoadMorePokemon succeeds',
    build: () {
      when(
        () => mockGetPokemonListUseCase(any()),
      ).thenAnswer((_) async => const Right(tMorePokemon));
      return homeBloc;
    },
    seed: () => const HomeState(pokemonList: tPokemonList, currentOffset: 2),
    act: (bloc) => bloc.add(const LoadMorePokemon()),
    expect: () => [
      const HomeState(
        isLoadingMore: true,
        pokemonList: tPokemonList,
        currentOffset: 2,
      ),
      const HomeState(
        isLoading: false,
        isLoadingMore: false,
        pokemonList: [...tPokemonList, ...tMorePokemon],
        currentOffset: 3,
      ),
    ],
    verify: (_) {
      verify(
        () => mockGetPokemonListUseCase(
          const PokemonListParams(limit: 20, offset: 2),
        ),
      ).called(1);
    },
  );

  blocTest<HomeBloc, HomeState>(
    'emits hasReachedMax when LoadMorePokemon returns empty list',
    build: () {
      when(
        () => mockGetPokemonListUseCase(any()),
      ).thenAnswer((_) async => const Right([]));
      return homeBloc;
    },
    seed: () => const HomeState(pokemonList: tPokemonList, currentOffset: 2),
    act: (bloc) => bloc.add(const LoadMorePokemon()),
    expect: () => [
      const HomeState(
        isLoadingMore: true,
        pokemonList: tPokemonList,
        currentOffset: 2,
      ),
      const HomeState(
        isLoading: false,
        isLoadingMore: false,
        pokemonList: tPokemonList,
        hasReachedMax: true,
        currentOffset: 2,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'does not emit when LoadMorePokemon is called while already loading',
    build: () {
      when(
        () => mockGetPokemonListUseCase(any()),
      ).thenAnswer((_) async => const Right(tMorePokemon));
      return homeBloc;
    },
    seed: () => const HomeState(
      isLoadingMore: true,
      pokemonList: tPokemonList,
      currentOffset: 2,
    ),
    act: (bloc) => bloc.add(const LoadMorePokemon()),
    expect: () => [],
    verify: (_) {
      verifyNever(() => mockGetPokemonListUseCase(any()));
    },
  );

  blocTest<HomeBloc, HomeState>(
    'does not emit when LoadMorePokemon is called and hasReachedMax is true',
    build: () => homeBloc,
    seed: () => const HomeState(
      pokemonList: tPokemonList,
      hasReachedMax: true,
      currentOffset: 2,
    ),
    act: (bloc) => bloc.add(const LoadMorePokemon()),
    expect: () => [],
    verify: (_) {
      verifyNever(() => mockGetPokemonListUseCase(any()));
    },
  );

  blocTest<HomeBloc, HomeState>(
    'emits loadingMore then error when LoadMorePokemon fails',
    build: () {
      when(
        () => mockGetPokemonListUseCase(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
      return homeBloc;
    },
    seed: () => const HomeState(pokemonList: tPokemonList, currentOffset: 2),
    act: (bloc) => bloc.add(const LoadMorePokemon()),
    expect: () => [
      const HomeState(
        isLoadingMore: true,
        pokemonList: tPokemonList,
        currentOffset: 2,
      ),
      const HomeState(
        isLoading: false,
        isLoadingMore: false,
        pokemonList: tPokemonList,
        failure: ServerFailure('Server error'),
        currentOffset: 2,
      ),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits initial state when LogoutRequested is added',
    build: () => homeBloc,
    seed: () => const HomeState(pokemonList: tPokemonList),
    act: (bloc) => bloc.add(const LogoutRequested()),
    expect: () => [const HomeState()],
  );
}
