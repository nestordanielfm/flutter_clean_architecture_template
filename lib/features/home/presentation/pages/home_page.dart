import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:template_app/core/router/app_router.gr.dart';
import 'package:template_app/features/home/presentation/store/home_store.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeStore _homeStore;

  @override
  void initState() {
    super.initState();
    _homeStore = getIt<HomeStore>();
    _homeStore.loadPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.router.replace(const LoginRoute());
            },
          ),
        ],
      ),
      body: Observer(
        builder: (context) {
          if (_homeStore.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_homeStore.isError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _homeStore.failure?.message ?? 'Error loading Pokémon',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _homeStore.loadPokemonList();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_homeStore.isSuccess && _homeStore.pokemonList != null) {
            return ListView.builder(
              itemCount: _homeStore.pokemonList!.length,
              itemBuilder: (context, index) {
                final pokemon = _homeStore.pokemonList![index];
                return ListTile(
                  leading: Image.network(
                    pokemon.imageUrl,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.catching_pokemon);
                    },
                  ),
                  title: Text(
                    pokemon.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID: ${pokemon.id}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    context.router.push(DetailRoute(pokemonId: pokemon.id));
                  },
                );
              },
            );
          }

          return const Center(child: Text('No Pokémon found'));
        },
      ),
    );
  }
}
