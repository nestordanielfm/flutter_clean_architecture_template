import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_event.dart';

void main() {
  group('DetailEvent', () {
    test('LoadPokemonDetail should have pokemonId', () {
      const event = LoadPokemonDetail(1);

      expect(event.pokemonId, 1);
      expect(event.props, [1]);
    });

    test('LoadPokemonDetail with same id should be equal', () {
      const event1 = LoadPokemonDetail(1);
      const event2 = LoadPokemonDetail(1);

      expect(event1, event2);
    });

    test('LoadPokemonDetail with different id should not be equal', () {
      const event1 = LoadPokemonDetail(1);
      const event2 = LoadPokemonDetail(2);

      expect(event1, isNot(event2));
    });

    test('LoadPokemonDetail should handle different pokemon ids', () {
      const event25 = LoadPokemonDetail(25);
      const event150 = LoadPokemonDetail(150);

      expect(event25.pokemonId, 25);
      expect(event150.pokemonId, 150);
      expect(event25, isNot(event150));
    });
  });
}
