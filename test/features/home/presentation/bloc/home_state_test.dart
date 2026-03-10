import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/home/presentation/bloc/home_state.dart';
import 'package:template_app/features/home/domain/entities/pokemon.dart';

void main() {
  group('HomeState', () {
    const tPokemonList = [
      Pokemon(id: 1, name: 'bulbasaur', imageUrl: 'url1'),
      Pokemon(id: 2, name: 'ivysaur', imageUrl: 'url2'),
    ];

    test('initial state should have default values', () {
      const state = HomeState();

      expect(state.isLoading, false);
      expect(state.isLoadingMore, false);
      expect(state.pokemonList, isNull);
      expect(state.failure, isNull);
      expect(state.hasReachedMax, false);
      expect(state.currentOffset, 0);
      expect(state.isInitial, true);
    });

    test('copyWith should update isLoading', () {
      const state = HomeState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, true);
      expect(newState.isLoadingMore, false);
    });

    test('copyWith should update isLoadingMore', () {
      const state = HomeState();
      final newState = state.copyWith(isLoadingMore: true);

      expect(newState.isLoading, false);
      expect(newState.isLoadingMore, true);
    });

    test('copyWith should update pokemonList', () {
      const state = HomeState();
      final newState = state.copyWith(pokemonList: tPokemonList);

      expect(newState.pokemonList, tPokemonList);
    });

    test('copyWith should update failure', () {
      const state = HomeState();
      const failure = ServerFailure('Error');
      final newState = state.copyWith(failure: failure);

      expect(newState.failure, failure);
    });

    test('copyWith should update hasReachedMax', () {
      const state = HomeState();
      final newState = state.copyWith(hasReachedMax: true);

      expect(newState.hasReachedMax, true);
    });

    test('copyWith should update currentOffset', () {
      const state = HomeState();
      final newState = state.copyWith(currentOffset: 20);

      expect(newState.currentOffset, 20);
    });

    test('isSuccess should return true when pokemonList is not empty', () {
      const state = HomeState(pokemonList: tPokemonList);
      expect(state.isSuccess, true);
    });

    test('isSuccess should return false when pokemonList is empty', () {
      const state = HomeState(pokemonList: []);
      expect(state.isSuccess, false);
    });

    test('isError should return true when failure is not null', () {
      const state = HomeState(failure: ServerFailure('Error'));
      expect(state.isError, true);
    });

    test('props should contain all properties', () {
      const state = HomeState(
        isLoading: true,
        isLoadingMore: false,
        pokemonList: tPokemonList,
        failure: ServerFailure('Error'),
        hasReachedMax: true,
        currentOffset: 10,
      );

      expect(state.props.length, 6);
    });
  });
}
