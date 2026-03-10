import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';
import 'package:template_app/features/home/domain/repositories/pokemon_repository.dart';
import 'package:template_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

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

void main() {
  late GetPokemonListUseCase useCase;
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    useCase = GetPokemonListUseCase(mockRepository);
  });

  const tParams = PokemonListParams(limit: 20, offset: 0);
  const tParamsWithOffset = PokemonListParams(limit: 20, offset: 20);

  test(
    'should return list of Pokemon when repository call is successful',
    () async {
      // Arrange
      when(
        () => mockRepository.getPokemonList(limit: 20, offset: 0),
      ).thenAnswer((_) async => const Right(tPokemonList));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, const Right(tPokemonList));
      verify(() => mockRepository.getPokemonList(limit: 20, offset: 0));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return list of Pokemon with custom offset', () async {
    // Arrange
    when(
      () => mockRepository.getPokemonList(limit: 20, offset: 20),
    ).thenAnswer((_) async => const Right(tPokemonList));

    // Act
    final result = await useCase(tParamsWithOffset);

    // Assert
    expect(result, const Right(tPokemonList));
    verify(() => mockRepository.getPokemonList(limit: 20, offset: 20));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // Arrange
    const tFailure = ServerFailure('Server error');
    when(
      () => mockRepository.getPokemonList(limit: 20, offset: 0),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.getPokemonList(limit: 20, offset: 0));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure on connection timeout', () async {
    // Arrange
    const tFailure = NetworkFailure('Connection timeout');
    when(
      () => mockRepository.getPokemonList(limit: 20, offset: 0),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.getPokemonList(limit: 20, offset: 0));
  });

  test('should return empty list when no pokemon available', () async {
    // Arrange
    const List<Pokemon> emptyList = [];
    when(
      () => mockRepository.getPokemonList(limit: 20, offset: 0),
    ).thenAnswer((_) async => const Right(emptyList));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Right<Failure, List<Pokemon>>(emptyList));
    verify(() => mockRepository.getPokemonList(limit: 20, offset: 0));
  });
}
