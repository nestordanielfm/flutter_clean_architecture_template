import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:template_app/core/network/dio_client.dart';
import 'package:template_app/features/detail/data/datasources/pokemon_detail_api.dart';
import 'package:template_app/features/detail/data/repositories/pokemon_detail_repository_impl.dart';
import 'package:template_app/features/detail/domain/repositories/pokemon_detail_repository.dart';
import 'package:template_app/features/detail/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:template_app/features/detail/presentation/store/detail_store.dart';
import 'package:template_app/features/home/data/datasources/pokemon_api.dart';
import 'package:template_app/features/home/data/repositories/pokemon_repository_impl.dart';
import 'package:template_app/features/home/domain/repositories/pokemon_repository.dart';
import 'package:template_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:template_app/features/home/presentation/store/home_store.dart';
import 'package:template_app/features/login/data/datasources/auth_api.dart';
import 'package:template_app/features/login/data/repositories/auth_repository_impl.dart';
import 'package:template_app/features/login/domain/repositories/auth_repository.dart';
import 'package:template_app/features/login/domain/usecases/login_usecase.dart';
import 'package:template_app/features/login/presentation/store/login_store.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Core - Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().dio);

  // Login feature
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt<Dio>()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthApi>()),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<LoginStore>(() => LoginStore(getIt<LoginUseCase>()));

  // Home feature
  getIt.registerLazySingleton<PokemonApi>(() => PokemonApi(getIt<Dio>()));
  getIt.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(getIt<PokemonApi>()),
  );
  getIt.registerLazySingleton<GetPokemonListUseCase>(
    () => GetPokemonListUseCase(getIt<PokemonRepository>()),
  );
  getIt.registerFactory<HomeStore>(
    () => HomeStore(getIt<GetPokemonListUseCase>()),
  );

  // Detail feature
  getIt.registerLazySingleton<PokemonDetailApi>(
    () => PokemonDetailApi(getIt<Dio>()),
  );
  getIt.registerLazySingleton<PokemonDetailRepository>(
    () => PokemonDetailRepositoryImpl(getIt<PokemonDetailApi>()),
  );
  getIt.registerLazySingleton<GetPokemonDetailUseCase>(
    () => GetPokemonDetailUseCase(getIt<PokemonDetailRepository>()),
  );
  getIt.registerFactory<DetailStore>(
    () => DetailStore(getIt<GetPokemonDetailUseCase>()),
  );
}
