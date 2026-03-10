import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_state.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';

void main() {
  group('DetailState', () {
    const tPokemonDetail = PokemonDetail(
      id: 1,
      name: 'bulbasaur',
      imageUrl: 'url',
      height: 7,
      weight: 69,
      types: ['grass', 'poison'],
      abilities: ['overgrow'],
    );

    test('initial state should have default values', () {
      const state = DetailState();

      expect(state.isLoading, false);
      expect(state.pokemonDetail, isNull);
      expect(state.failure, isNull);
      expect(state.isInitial, true);
      expect(state.isSuccess, false);
      expect(state.isError, false);
    });

    test('copyWith should update isLoading', () {
      const state = DetailState();
      final newState = state.copyWith(isLoading: true);

      expect(newState.isLoading, true);
      expect(newState.pokemonDetail, isNull);
      expect(newState.failure, isNull);
    });

    test('copyWith should update pokemonDetail', () {
      const state = DetailState();
      final newState = state.copyWith(pokemonDetail: tPokemonDetail);

      expect(newState.isLoading, false);
      expect(newState.pokemonDetail, tPokemonDetail);
      expect(newState.failure, isNull);
    });

    test('copyWith should update failure', () {
      const state = DetailState();
      const failure = ServerFailure('Error');
      final newState = state.copyWith(failure: failure);

      expect(newState.isLoading, false);
      expect(newState.pokemonDetail, isNull);
      expect(newState.failure, failure);
    });

    test('toLoading should set isLoading to true', () {
      const state = DetailState(failure: ServerFailure('Error'));
      final newState = state.toLoading();

      expect(newState.isLoading, true);
      // Note: failure is not cleared by copyWith, this is expected behavior
    });

    test(
      'toSuccess should set pokemonDetail and clear loading and failure',
      () {
        const state = DetailState(isLoading: true);
        final newState = state.toSuccess(tPokemonDetail);

        expect(newState.isLoading, false);
        expect(newState.pokemonDetail, tPokemonDetail);
        expect(newState.failure, isNull);
        expect(newState.isSuccess, true);
      },
    );

    test('toError should set failure and clear loading', () {
      const state = DetailState(isLoading: true);
      const failure = ServerFailure('Error');
      final newState = state.toError(failure);

      expect(newState.isLoading, false);
      expect(newState.failure, failure);
      expect(newState.isError, true);
    });

    test('isSuccess should return true when pokemonDetail is not null', () {
      const state = DetailState(pokemonDetail: tPokemonDetail);
      expect(state.isSuccess, true);
    });

    test('isError should return true when failure is not null', () {
      const state = DetailState(failure: ServerFailure('Error'));
      expect(state.isError, true);
    });

    test(
      'isInitial should return true when not loading and no detail or failure',
      () {
        const state = DetailState();
        expect(state.isInitial, true);
      },
    );

    test('props should contain all properties', () {
      const failure = ServerFailure('Error');
      const state = DetailState(
        isLoading: true,
        pokemonDetail: tPokemonDetail,
        failure: failure,
      );

      expect(state.props, [true, tPokemonDetail, failure]);
    });

    test('states with same properties should be equal', () {
      const state1 = DetailState(
        isLoading: true,
        pokemonDetail: tPokemonDetail,
      );
      const state2 = DetailState(
        isLoading: true,
        pokemonDetail: tPokemonDetail,
      );

      expect(state1, state2);
    });
  });
}
