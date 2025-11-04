import 'package:equatable/equatable.dart';
import 'package:template_app/core/error/failures.dart';
import 'package:template_app/features/detail/domain/entities/pokemon_detail.dart';

class DetailState extends Equatable {
  final bool isLoading;
  final PokemonDetail? pokemonDetail;
  final Failure? failure;

  const DetailState({this.isLoading = false, this.pokemonDetail, this.failure});

  // Helper getters
  bool get isSuccess => pokemonDetail != null;
  bool get isError => failure != null;
  bool get isInitial => !isLoading && pokemonDetail == null && failure == null;

  // copyWith for state updates
  DetailState copyWith({
    bool? isLoading,
    PokemonDetail? pokemonDetail,
    Failure? failure,
  }) {
    return DetailState(
      isLoading: isLoading ?? this.isLoading,
      pokemonDetail: pokemonDetail ?? this.pokemonDetail,
      failure: failure ?? this.failure,
    );
  }

  // Helper methods
  DetailState toLoading() => copyWith(isLoading: true, failure: null);
  DetailState toSuccess(PokemonDetail pokemonDetail) =>
      copyWith(isLoading: false, pokemonDetail: pokemonDetail, failure: null);
  DetailState toError(Failure failure) =>
      copyWith(isLoading: false, failure: failure);

  @override
  List<Object?> get props => [isLoading, pokemonDetail, failure];
}
