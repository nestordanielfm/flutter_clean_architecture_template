import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/core/router/app_router.gr.dart';
import 'package:template_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:template_app/features/home/presentation/bloc/home_event.dart';
import 'package:template_app/features/home/presentation/bloc/home_state.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const LoadPokemonList()),
      child: Scaffold(
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
        body: BlocBuilder<HomeBloc, HomeState>(
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
                      state.failure?.message ?? 'Error loading Pokémon',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(const LoadPokemonList());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state.isSuccess && state.pokemonList != null) {
              return ListView.builder(
                itemCount: state.pokemonList!.length,
                itemBuilder: (context, index) {
                  final pokemon = state.pokemonList![index];
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
      ),
    );
  }
}
