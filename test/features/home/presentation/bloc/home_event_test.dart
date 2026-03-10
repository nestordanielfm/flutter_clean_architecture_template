import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/features/home/presentation/bloc/home_event.dart';

void main() {
  group('HomeEvent', () {
    test('LoadPokemonList should have empty props', () {
      const event = LoadPokemonList();

      expect(event.props, <Object?>[]);
    });

    test('LoadPokemonList instances should be equal', () {
      const event1 = LoadPokemonList();
      const event2 = LoadPokemonList();

      expect(event1, event2);
    });

    test('LoadMorePokemon should have empty props', () {
      const event = LoadMorePokemon();

      expect(event.props, <Object?>[]);
    });

    test('LoadMorePokemon instances should be equal', () {
      const event1 = LoadMorePokemon();
      const event2 = LoadMorePokemon();

      expect(event1, event2);
    });

    test('LogoutRequested should have empty props', () {
      const event = LogoutRequested();

      expect(event.props, <Object?>[]);
    });

    test('LogoutRequested instances should be equal', () {
      const event1 = LogoutRequested();
      const event2 = LogoutRequested();

      expect(event1, event2);
    });

    test('different events should not be equal', () {
      const event1 = LoadPokemonList();
      const event2 = LoadMorePokemon();

      expect(event1, isNot(event2));
    });
  });
}
