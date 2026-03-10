import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';
import 'package:template_app/features/detail/domain/repositories/pokemon_detail_repository.dart';
import 'package:template_app/features/detail/domain/usecases/get_pokemon_detail_usecase.dart';

class MockPokemonDetailRepository extends Mock
    implements PokemonDetailRepository {}

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
  late GetPokemonDetailUseCase useCase;
  late MockPokemonDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonDetailRepository();
    useCase = GetPokemonDetailUseCase(mockRepository);
  });

  const tParams = PokemonDetailParams(id: 1);
  const tParamsAnotherPokemon = PokemonDetailParams(id: 25);

  test(
    'should return PokemonDetail when repository call is successful',
    () async {
      // Arrange
      when(
        () => mockRepository.getPokemonDetail(1),
      ).thenAnswer((_) async => const Right(tPokemonDetail));

      // Act
      final result = await useCase(tParams);

      // Assert
      expect(result, const Right(tPokemonDetail));
      verify(() => mockRepository.getPokemonDetail(1));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should call repository with correct id', () async {
    // Arrange
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
      () => mockRepository.getPokemonDetail(25),
    ).thenAnswer((_) async => const Right(tPikachu));

    // Act
    final result = await useCase(tParamsAnotherPokemon);

    // Assert
    expect(result, const Right(tPikachu));
    verify(() => mockRepository.getPokemonDetail(25));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository call fails', () async {
    // Arrange
    const tFailure = ServerFailure('Server error');
    when(
      () => mockRepository.getPokemonDetail(1),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.getPokemonDetail(1));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return NetworkFailure on connection timeout', () async {
    // Arrange
    const tFailure = NetworkFailure('Connection timeout');
    when(
      () => mockRepository.getPokemonDetail(1),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(tParams);

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.getPokemonDetail(1));
  });

  test('should return ServerFailure when Pokemon not found', () async {
    // Arrange
    const tFailure = ServerFailure('Pokemon not found');
    when(
      () => mockRepository.getPokemonDetail(999999),
    ).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(const PokemonDetailParams(id: 999999));

    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.getPokemonDetail(999999));
  });
}
