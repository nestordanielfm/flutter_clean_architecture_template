import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:template_app/features/detail/presentation/store/detail_store.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class DetailPage extends StatefulWidget {
  final int pokemonId;

  const DetailPage({super.key, @PathParam('id') required this.pokemonId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final DetailStore _detailStore;

  @override
  void initState() {
    super.initState();
    _detailStore = getIt<DetailStore>();
    _detailStore.loadPokemonDetail(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon Detail')),
      body: Observer(
        builder: (context) {
          if (_detailStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_detailStore.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _detailStore.failure?.message ?? 'Error loading Pokémon details',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _detailStore.loadPokemonDetail(widget.pokemonId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_detailStore.isSuccess && _detailStore.pokemonDetail != null) {
            final pokemon = _detailStore.pokemonDetail!;
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
