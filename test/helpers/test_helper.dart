import 'package:mocktail/mocktail.dart';
import 'package:template_app/features/detail/domain/repositories/pokemon_detail_repository.dart';
import 'package:template_app/features/detail/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:template_app/features/home/domain/repositories/pokemon_repository.dart';
import 'package:template_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:template_app/features/login/domain/repositories/auth_repository.dart';
import 'package:template_app/features/login/domain/usecases/login_usecase.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';
import 'package:template_app/features/login/domain/entities/user.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}

class MockPokemonRepository extends Mock implements PokemonRepository {}

class MockPokemonDetailRepository extends Mock
    implements PokemonDetailRepository {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockGetPokemonListUseCase extends Mock implements GetPokemonListUseCase {}

class MockGetPokemonDetailUseCase extends Mock
    implements GetPokemonDetailUseCase {}

// Test fixtures
class TestFixtures {
  static const tUser = User(
    id: 1,
    username: 'testuser',
    email: 'test@example.com',
    token: 'test_token_123',
    firstName: 'Test',
    lastName: 'User',
  );

  static const tPokemonList = [
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

  static const tPokemonDetail = PokemonDetail(
    id: 1,
    name: 'bulbasaur',
    imageUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    height: 7,
    weight: 69,
    types: ['grass', 'poison'],
    abilities: ['overgrow', 'chlorophyll'],
  );
}
