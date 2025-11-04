import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_bloc.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_event.dart';
import 'package:template_app/features/detail/presentation/bloc/detail_state.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class DetailPage extends StatelessWidget {
  final int pokemonId;

  const DetailPage({super.key, @PathParam('id') required this.pokemonId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DetailBloc>()..add(LoadPokemonDetail(pokemonId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Pokémon Detail')),
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.isError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.failure?.message ?? 'Error loading Pokémon details',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DetailBloc>().add(
                          LoadPokemonDetail(pokemonId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state.isSuccess && state.pokemonDetail != null) {
              final pokemon = state.pokemonDetail!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      pokemon.imageUrl,
                      width: 200,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.catching_pokemon, size: 200);
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      pokemon.name.toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ID: ${pokemon.id}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoRow('Height', '${pokemon.height / 10} m'),
                            const Divider(),
                            _buildInfoRow(
                              'Weight',
                              '${pokemon.weight / 10} kg',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Types',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: pokemon.types
                                  .map(
                                    (type) =>
                                        Chip(label: Text(type.toUpperCase())),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Abilities',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: pokemon.abilities
                                  .map(
                                    (ability) => Chip(
                                      label: Text(ability.toUpperCase()),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
