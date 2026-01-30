import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:template_app/core/config/environment.dart';
import 'package:template_app/core/network/dio_client.dart';
import 'package:template_app/features/episodes/data/datasources/episodes_api.dart';
import 'package:template_app/features/episodes/data/repositories/episodes_repository_impl.dart';
import 'package:template_app/features/episodes/domain/repositories/episodes_repository.dart';
import 'package:template_app/features/episodes/domain/usecases/get_seasons_usecase.dart';
import 'package:template_app/features/episodes/presentation/store/episodes_store.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Core - Dio Client
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().dio);

  // Episodes feature
  getIt.registerLazySingleton<EpisodesApi>(
    () => EpisodesApi(getIt<Dio>(), baseUrl: EnvironmentConfig.futuramaApiUrl),
  );
  getIt.registerLazySingleton<EpisodesRepository>(
    () => EpisodesRepositoryImpl(getIt<EpisodesApi>()),
  );
  getIt.registerLazySingleton<GetSeasonsUseCase>(
    () => GetSeasonsUseCase(getIt<EpisodesRepository>()),
  );
  getIt.registerFactory<EpisodesStore>(
    () => EpisodesStore(getIt<GetSeasonsUseCase>()),
  );
}
