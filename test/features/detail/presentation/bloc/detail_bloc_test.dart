import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';
import 'package:template_app/features/detail/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_event.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_state.dart';

class MockGetPokemonDetailUseCase extends Mock
    implements GetPokemonDetailUseCase {}

const tPokemonDetail = PokemonDetail(
  id: 1,
  name: 'bulbasaur',
  imageUrl:
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
  height: 7,
  weight: 69,
  types: ['grass', 'poison'],
  abilities: ['overgrow', 'chlorophyll'],
);

void main() {
  late DetailBloc detailBloc;
  late MockGetPokemonDetailUseCase mockGetPokemonDetailUseCase;

  setUp(() {
    mockGetPokemonDetailUseCase = MockGetPokemonDetailUseCase();
    detailBloc = DetailBloc(mockGetPokemonDetailUseCase);
  });

  setUpAll(() {
    registerFallbackValue(const PokemonDetailParams(id: 1));
  });

  tearDown(() {
    detailBloc.close();
  });

  const tParams = PokemonDetailParams(id: 1);

  test('initial state should be DetailState with default values', () {
    expect(detailBloc.state, const DetailState());
    expect(detailBloc.state.isInitial, true);
  });

  blocTest<DetailBloc, DetailState>(
    'emits loading then success when LoadPokemonDetail succeeds',
    build: () {
      when(
        () => mockGetPokemonDetailUseCase(any()),
      ).thenAnswer((_) async => const Right(tPokemonDetail));
      return detailBloc;
    },
    act: (bloc) => bloc.add(const LoadPokemonDetail(1)),
    expect: () => [
      const DetailState(isLoading: true),
      const DetailState(isLoading: false, pokemonDetail: tPokemonDetail),
    ],
    verify: (_) {
      verify(() => mockGetPokemonDetailUseCase(tParams)).called(1);
    },
  );

  blocTest<DetailBloc, DetailState>(
    'emits loading then success with different Pokemon',
    build: () {
      const tPikachu = PokemonDetail(
        id: 25,
        name: 'pikachu',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
        height: 4,
        weight: 60,
        types: ['electric'],
        abilities: ['static', 'lightning-rod'],
      );
      when(
        () => mockGetPokemonDetailUseCase(any()),
      ).thenAnswer((_) async => const Right(tPikachu));
      return detailBloc;
    },
    act: (bloc) => bloc.add(const LoadPokemonDetail(25)),
    expect: () {
      const tPikachu = PokemonDetail(
        id: 25,
        name: 'pikachu',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
        height: 4,
        weight: 60,
        types: ['electric'],
        abilities: ['static', 'lightning-rod'],
      );
      return [
        const DetailState(isLoading: true),
        const DetailState(isLoading: false, pokemonDetail: tPikachu),
      ];
    },
    verify: (_) {
      verify(
        () => mockGetPokemonDetailUseCase(const PokemonDetailParams(id: 25)),
      ).called(1);
    },
  );

  blocTest<DetailBloc, DetailState>(
    'emits loading then error when LoadPokemonDetail fails with ServerFailure',
    build: () {
      when(
        () => mockGetPokemonDetailUseCase(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('Server error')));
      return detailBloc;
    },
    act: (bloc) => bloc.add(const LoadPokemonDetail(1)),
    expect: () => [
      const DetailState(isLoading: true),
      const DetailState(
        isLoading: false,
        failure: ServerFailure('Server error'),
      ),
    ],
  );

  blocTest<DetailBloc, DetailState>(
    'emits loading then error when LoadPokemonDetail fails with NetworkFailure',
    build: () {
      when(() => mockGetPokemonDetailUseCase(any())).thenAnswer(
        (_) async => const Left(NetworkFailure('Connection timeout')),
      );
      return detailBloc;
    },
    act: (bloc) => bloc.add(const LoadPokemonDetail(1)),
    expect: () => [
      const DetailState(isLoading: true),
      const DetailState(
        isLoading: false,
        failure: NetworkFailure('Connection timeout'),
      ),
    ],
  );

  blocTest<DetailBloc, DetailState>(
    'emits loading then error when Pokemon not found',
    build: () {
      when(
        () => mockGetPokemonDetailUseCase(any()),
      ).thenAnswer((_) async => const Left(ServerFailure('Pokemon not found')));
      return detailBloc;
    },
    act: (bloc) => bloc.add(const LoadPokemonDetail(999999)),
    expect: () => [
      const DetailState(isLoading: true),
      const DetailState(
        isLoading: false,
        failure: ServerFailure('Pokemon not found'),
      ),
    ],
    verify: (_) {
      verify(
        () =>
            mockGetPokemonDetailUseCase(const PokemonDetailParams(id: 999999)),
      ).called(1);
    },
  );

  blocTest<DetailBloc, DetailState>(
    'handles multiple LoadPokemonDetail events correctly',
    build: () {
      when(
        () => mockGetPokemonDetailUseCase(any()),
      ).thenAnswer((_) async => const Right(tPokemonDetail));
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadPokemonDetail(1));
      bloc.add(const LoadPokemonDetail(2));
    },
    expect: () => [
      const DetailState(isLoading: true),
      const DetailState(isLoading: false, pokemonDetail: tPokemonDetail),
      const DetailState(isLoading: true, pokemonDetail: tPokemonDetail),
      const DetailState(isLoading: false, pokemonDetail: tPokemonDetail),
    ],
  );
}
