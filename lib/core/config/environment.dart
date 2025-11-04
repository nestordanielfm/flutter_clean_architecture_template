enum Environment { dev, prod }

class EnvironmentConfig {
  static late Environment _environment;

  static void init({String? env}) {
    _environment = env == 'prod' ? Environment.prod : Environment.dev;
  }

  static Environment get environment => _environment;
  static bool get isDev => _environment == Environment.dev;
  static bool get isProd => _environment == Environment.prod;

  static String get baseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'https://dummyjson.com';
      case Environment.prod:
        return 'https://api.production.com'; // Replace with actual prod URL
    }
  }

  static String get pokemonBaseUrl => 'https://pokeapi.co/api/v2';

  static Duration get connectionTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);
}
