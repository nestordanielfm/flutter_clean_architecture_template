import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/core/router/app_router.gr.dart';
import 'package:template_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:template_app/features/home/presentation/bloc/home_event.dart';
import 'package:template_app/features/home/presentation/bloc/home_state.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = getIt<HomeBloc>()..add(const LoadPokemonList());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _homeBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _homeBloc.add(const LoadMorePokemon());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeBloc,
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

            if (state.isError &&
                (state.pokemonList == null || state.pokemonList!.isEmpty)) {
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

            if (state.isSuccess) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.pokemonList!.length
                    : state.pokemonList!.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.pokemonList!.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

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
