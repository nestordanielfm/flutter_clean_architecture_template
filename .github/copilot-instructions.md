# 🧱 Flutter Template Generator — AI Coding Instructions

## 🎯 Project Overview

This is a **starter template** for building Flutter apps with **feature-based Clean Architecture**, **SOLID principles**, and **BLoC pattern**.

**Current Status**: Fresh Flutter project - architecture not yet implemented.

**Target Platforms**: Android and iOS only.

**Target Implementation**: Login → Home (Pokémon list) → Detail flow with each feature containing isolated architecture layers.

### Quick Start for AI Agents
- This is a **prescriptive template** - follow these patterns when generating code
- **No existing features yet** - you'll be creating the initial architecture
- All dependencies must be added to `pubspec.yaml` (currently minimal Flutter setup)
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after generating models/APIs
- Use environment-based configuration for API endpoints

---

## 🔨 Critical Commands (Run After Code Generation)

```bash
# Add all required dependencies first
flutter pub add flutter_bloc equatable dio retrofit auto_route get_it dartz json_annotation flutter_dotenv
flutter pub add -d build_runner retrofit_generator json_serializable auto_route_generator mocktail bloc_test

# Generate code for models, APIs, and routes
flutter pub run build_runner build --delete-conflicting-outputs

# Verify setup
flutter pub get
flutter analyze

# Run the app (default environment)
flutter run

# Run with specific environment
flutter run --dart-define=ENV=dev
flutter run --dart-define=ENV=prod

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage
```

---

## 🏗️ Architecture Implementation Rules

### 📁 Directory Structure (Feature-Based + Clean Architecture)

```
lib/
├── core/                    # Global configurations, constants, utilities, and error handling
│   ├── config/
│   │   └── environment.dart # Environment configuration (dev/prod)
│   ├── error/
│   │   ├── failures.dart    # Failure classes
│   │   └── exceptions.dart  # Exception classes
│   ├── network/
│   │   └── dio_client.dart  # Dio configuration with interceptors
│   └── router/
│       └── app_router.dart  # AutoRoute configuration
├── features/                # Each feature has its own architecture layers
│   ├── login/
│   │   ├── data/            # Data layer: DTOs, Retrofit clients, repository impls
│   │   ├── domain/          # Domain layer: entities, use cases, repository interfaces
│   │   └── presentation/    # Presentation layer: BLoC, pages, widgets
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── detail/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── injection/               # GetIt dependency injection setup
│   └── injection.dart
└── main.dart
```

Each feature must be **self-contained** — meaning:
- No feature should depend on another.
- Shared utilities or common classes go in `core/`.

---

## 🔁 Layer Dependencies (Strict)

- **Domain** → No external dependencies (pure Dart)
- **Data** → Depends only on `Domain` abstractions
- **Presentation** → Depends on `Domain` (use cases) via BLoC
- **Flow:** UI → BLoC → UseCase → Repository → DataSource

---

## ⚠️ Error Handling (Core Pattern)

### Exception Classes (`lib/core/error/exceptions.dart`)
```dart
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  ServerException(this.message, [this.statusCode]);
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  
  CacheException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  
  UnauthorizedException(this.message);
}
```

### Failure Classes (`lib/core/error/failures.dart`)
```dart
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(String message) : super(message);
}
```

### Repository Error Handling Pattern
```dart
@override
Future<Either<Failure, User>> login(LoginParams params) async {
  try {
    final response = await authApi.login(params.toDto());
    return Right(response.toEntity());
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const Left(NetworkFailure('Connection timeout'));
    }
    if (e.response?.statusCode == 401) {
      return const Left(UnauthorizedFailure('Invalid credentials'));
    }
    if (e.response?.statusCode != null && e.response!.statusCode! >= 500) {
      return const Left(ServerFailure('Server error'));
    }
    return Left(ServerFailure(e.message ?? 'Unknown error'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

---

## 🌐 Environment Configuration

### Setup (`lib/core/config/environment.dart`)
```dart
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
```

### Initialize in `main.dart`
```dart
void main() {
  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  EnvironmentConfig.init(env: env);
  
  configureDependencies();
  runApp(MyApp());
}
```

### Dio Configuration (`lib/core/network/dio_client.dart`)
```dart
class DioClient {
  late final Dio dio;
  
  DioClient() {
    dio = Dio(
      BaseOptions(
        connectTimeout: EnvironmentConfig.connectionTimeout,
        receiveTimeout: EnvironmentConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Add interceptors
    dio.interceptors.add(LogInterceptor(
      requestBody: EnvironmentConfig.isDev,
      responseBody: EnvironmentConfig.isDev,
      error: true,
      requestHeader: EnvironmentConfig.isDev,
      responseHeader: false,
    ));
    
    // Add auth interceptor if needed
    dio.interceptors.add(AuthInterceptor());
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    // final token = getIt<TokenStorage>().getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    super.onRequest(options, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 globally
    if (err.response?.statusCode == 401) {
      // Clear token and navigate to login
    }
    super.onError(err, handler);
  }
}
```

---

## 💡 SOLID Principles (Mandatory)

All code must respect **SOLID** principles:

| Principle | Description |
|------------|--------------|
| **S** | **Single Responsibility:** Each class should have one clear responsibility (e.g., `LoginUseCase` only handles login). |
| **O** | **Open/Closed:** Code should be open for extension but closed for modification. Use abstract classes and contracts. |
| **L** | **Liskov Substitution:** Subclasses or implementations must be interchangeable without breaking behavior. |
| **I** | **Interface Segregation:** Keep interfaces small and focused (e.g., separate repositories per feature). |
| **D** | **Dependency Inversion:** Depend on abstractions, not concretions. Inject dependencies via constructors. |

---

## ⚙️ Technology Stack

| Purpose | Package |
|----------|----------|
| State Management | `flutter_bloc` + `equatable` |
| HTTP Client | `retrofit` + `dio` |
| Navigation | `auto_route` |
| Dependency Injection | `get_it` |
| Error Handling | `dartz` (Either pattern) |
| Code Generation | `build_runner`, `json_serializable`, `retrofit_generator`, `auto_route_generator` |

---

## 🧩 Feature Example: Login

```
lib/features/login/
├── data/
│   ├── datasources/auth_api.dart
│   ├── models/login_request.dart
│   ├── models/auth_response.dart
│   └── repositories/auth_repository_impl.dart
├── domain/
│   ├── entities/user.dart
│   ├── repositories/auth_repository.dart
│   └── usecases/login_usecase.dart
└── presentation/
    ├── bloc/login_bloc.dart
    ├── pages/login_page.dart
    └── widgets/login_form.dart
```

**Flow:**
`LoginPage` → `LoginBloc` → `LoginUseCase` → `AuthRepository` → `AuthApi`

---

## 🌍 Feature Responsibilities

### 🔐 Login Feature
- **API:** `POST https://dummyjson.com/auth/login`
- **Request:** `{ "username": "...", "password": "...", "expiresInMins": 30 }`
- **Response:** Token + user info
- **Navigation:** On success → `HomePage`

### 🏠 Home Feature
- **API:** `GET https://pokeapi.co/api/v2/pokemon?limit=20`
- **Display:** List of Pokémon (name, type, image)
- **Navigation:** Tap → `DetailPage`
- **Logout:** Returns to LoginPage

### 📘 Detail Feature
- **API:** `GET https://pokeapi.co/api/v2/pokemon/{id}`
- **Display:** Full Pokémon details (stats, abilities, image)
- **Back navigation:** Returns to HomePage

---

## 🧠 Code Standards

### BLoC State Composition Pattern

**States should be composition-based, not inheritance-based:**

```dart
// ❌ AVOID: Inheritance-based states
abstract class LoginState extends Equatable {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {}
class LoginError extends LoginState {}

// ✅ PREFER: Composition-based state
class LoginState extends Equatable {
  final bool isLoading;
  final User? user;
  final Failure? failure;
  
  const LoginState({
    this.isLoading = false,
    this.user,
    this.failure,
  });
  
  // Helper getters
  bool get isSuccess => user != null;
  bool get isError => failure != null;
  bool get isInitial => !isLoading && user == null && failure == null;
  
  // copyWith for state updates
  LoginState copyWith({
    bool? isLoading,
    User? user,
    Failure? failure,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      failure: failure ?? this.failure,
    );
  }
  
  // Reset helpers
  LoginState toLoading() => copyWith(isLoading: true, failure: null);
  LoginState toSuccess(User user) => copyWith(isLoading: false, user: user, failure: null);
  LoginState toError(Failure failure) => copyWith(isLoading: false, failure: failure);
  
  @override
  List<Object?> get props => [isLoading, user, failure];
}
```

**Events remain simple:**
```dart
abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;
  
  const LoginSubmitted({required this.username, required this.password});
  
  @override
  List<Object?> get props => [username, password];
}

class LoginReset extends LoginEvent {}
```

**BLoC implementation with composition:**
```dart
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  
  LoginBloc(this.loginUseCase) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }
  
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.toLoading());
    
    final result = await loginUseCase(
      LoginParams(username: event.username, password: event.password),
    );
    
    result.fold(
      (failure) => emit(state.toError(failure)),
      (user) => emit(state.toSuccess(user)),
    );
  }
  
  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }
}
```

### UseCase Pattern with Dartz
```dart
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params);
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;
  
  const LoginParams({required this.username, required this.password});
  
  @override
  List<Object> get props => [username, password];
}
```

### Retrofit Example
```dart
@RestApi(baseUrl: "https://dummyjson.com")
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST("/auth/login")
  Future<AuthResponse> login(@Body() LoginRequest request);
}
```

---

## 🧭 Navigation (AutoRoute)

Generate `lib/core/router/app_router.dart`:

```dart
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  final routes = [
    AutoRoute(page: LoginRoute.page, initial: true),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: DetailRoute.page),
  ];
}
```

Initialize in `main.dart`:
```dart
void main() {
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
    );
  }
}
```

---

## 🧩 Dependency Injection (GetIt)

Create `lib/injection/injection.dart` - each feature registers its own dependencies:

```dart
final getIt = GetIt.instance;

void configureDependencies() {
  // Shared
  getIt.registerLazySingleton(() => Dio());

  // Login feature
  getIt.registerLazySingleton<AuthApi>(() => AuthApi(getIt()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt()));
  getIt.registerFactory(() => LoginBloc(getIt()));

  // Home feature
  getIt.registerLazySingleton<PokemonApi>(() => PokemonApi(getIt()));
  getIt.registerLazySingleton<PokemonRepository>(() => PokemonRepositoryImpl(getIt()));
  getIt.registerFactory(() => HomeBloc(getIt()));

  // Detail feature
  getIt.registerFactory(() => DetailBloc(getIt()));
}
```

Access in BLoC constructors:
```dart
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  
  LoginBloc(this.loginUseCase) : super(LoginInitial());
}

// In presentation:
BlocProvider(
  create: (_) => getIt<LoginBloc>(),
  child: LoginPage(),
)
```

---

## 🧪 Testing Guidelines

Each feature must include:
- **Use case tests:** Pure Dart unit tests.
- **BLoC tests:** Using `bloc_test`.
- **Repository mocks:** Using `mocktail`.

Example structure:
```
test/
├── features/
│   ├── login/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── login_usecase_test.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── login_bloc_test.dart
│   ├── home/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── get_pokemon_list_usecase_test.dart
│   │   └── presentation/
│   │       └── bloc/
│   │           └── home_bloc_test.dart
│   └── detail/
│       ├── domain/
│       │   └── usecases/
│       │       └── get_pokemon_detail_usecase_test.dart
│       └── presentation/
│           └── bloc/
│               └── detail_bloc_test.dart
└── helpers/
    └── test_helper.dart  # Shared mocks and fixtures
```

### UseCase Test Example (`test/features/login/domain/usecases/login_usecase_test.dart`)
```dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;
  
  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });
  
  const tParams = LoginParams(username: 'testuser', password: 'password123');
  const tUser = User(id: 1, username: 'testuser', email: 'test@example.com');
  
  test('should return User when repository call is successful', () async {
    // Arrange
    when(() => mockRepository.login(tParams))
        .thenAnswer((_) async => const Right(tUser));
    
    // Act
    final result = await useCase(tParams);
    
    // Assert
    expect(result, const Right(tUser));
    verify(() => mockRepository.login(tParams));
    verifyNoMoreInteractions(mockRepository);
  });
  
  test('should return ServerFailure when repository call fails', () async {
    // Arrange
    const tFailure = ServerFailure('Server error');
    when(() => mockRepository.login(tParams))
        .thenAnswer((_) async => const Left(tFailure));
    
    // Act
    final result = await useCase(tParams);
    
    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.login(tParams));
    verifyNoMoreInteractions(mockRepository);
  });
  
  test('should return UnauthorizedFailure on invalid credentials', () async {
    // Arrange
    const tFailure = UnauthorizedFailure('Invalid credentials');
    when(() => mockRepository.login(tParams))
        .thenAnswer((_) async => const Left(tFailure));
    
    // Act
    final result = await useCase(tParams);
    
    // Assert
    expect(result, const Left(tFailure));
    verify(() => mockRepository.login(tParams));
  });
}
```

### BLoC Test Example (`test/features/login/presentation/bloc/login_bloc_test.dart`)
```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginUseCase mockLoginUseCase;
  
  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(mockLoginUseCase);
  });
  
  setUpAll(() {
    registerFallbackValue(const LoginParams(username: '', password: ''));
  });
  
  tearDown(() {
    loginBloc.close();
  });
  
  const tUser = User(id: 1, username: 'testuser', email: 'test@example.com');
  const tParams = LoginParams(username: 'testuser', password: 'password123');
  
  test('initial state should be LoginState with default values', () {
    expect(loginBloc.state, const LoginState());
    expect(loginBloc.state.isInitial, true);
  });
  
  blocTest<LoginBloc, LoginState>(
    'emits loading then success when login succeeds',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Right(tUser));
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      const LoginSubmitted(username: 'testuser', password: 'password123'),
    ),
    expect: () => [
      const LoginState(isLoading: true),
      const LoginState(isLoading: false, user: tUser),
    ],
    verify: (_) {
      verify(() => mockLoginUseCase(tParams)).called(1);
    },
  );
  
  blocTest<LoginBloc, LoginState>(
    'emits loading then error when login fails with ServerFailure',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      const LoginSubmitted(username: 'testuser', password: 'wrong'),
    ),
    expect: () => [
      const LoginState(isLoading: true),
      const LoginState(isLoading: false, failure: ServerFailure('Server error')),
    ],
  );
  
  blocTest<LoginBloc, LoginState>(
    'emits loading then error when login fails with UnauthorizedFailure',
    build: () {
      when(() => mockLoginUseCase(any()))
          .thenAnswer((_) async => const Left(UnauthorizedFailure('Invalid credentials')));
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      const LoginSubmitted(username: 'testuser', password: 'wrong'),
    ),
    expect: () => [
      const LoginState(isLoading: true),
      const LoginState(isLoading: false, failure: UnauthorizedFailure('Invalid credentials')),
    ],
  );
  
  blocTest<LoginBloc, LoginState>(
    'emits initial state when LoginReset is added',
    build: () => loginBloc,
    seed: () => const LoginState(
      isLoading: false,
      failure: ServerFailure('Error'),
    ),
    act: (bloc) => bloc.add(LoginReset()),
    expect: () => [const LoginState()],
  );
}
```

### Test Helper (`test/helpers/test_helper.dart`)
```dart
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockAuthRepository extends Mock implements AuthRepository {}
class MockPokemonRepository extends Mock implements PokemonRepository {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockGetPokemonListUseCase extends Mock implements GetPokemonListUseCase {}
class MockGetPokemonDetailUseCase extends Mock implements GetPokemonDetailUseCase {}

// Test fixtures
class TestFixtures {
  static const tUser = User(
    id: 1,
    username: 'testuser',
    email: 'test@example.com',
    token: 'test_token_123',
  );
  
  static const tPokemonList = [
    Pokemon(id: 1, name: 'bulbasaur', imageUrl: 'https://...'),
    Pokemon(id: 2, name: 'ivysaur', imageUrl: 'https://...'),
  ];
  
  static const tPokemonDetail = PokemonDetail(
    id: 1,
    name: 'bulbasaur',
    imageUrl: 'https://...',
    height: 7,
    weight: 69,
    types: ['grass', 'poison'],
    abilities: ['overgrow', 'chlorophyll'],
  );
}
```

---

## 🔨 Essential Commands Reference

```bash
# Code generation
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run build_runner watch --delete-conflicting-outputs  # Watch mode

# Testing
flutter test                                    # Run all tests
flutter test test/features/login                # Test specific feature
flutter test --coverage                         # Generate coverage
flutter test --coverage && genhtml coverage/lcov.info -o coverage/html  # HTML report

# Running
flutter run                                     # Dev environment (default)
flutter run --dart-define=ENV=prod             # Production environment
flutter run --release                           # Release mode

# Build
flutter build apk --dart-define=ENV=prod       # Android APK
flutter build appbundle --dart-define=ENV=prod # Android App Bundle
flutter build ios --dart-define=ENV=prod       # iOS

# Analysis
flutter analyze                                 # Static analysis
dart format lib test -l 80                      # Format code
```

---

## 📋 Implementation Checklist

When creating a new feature:
1. Create folder `lib/features/{feature_name}`
2. Inside it, create `data/`, `domain/`, `presentation/` folders.
3. Implement:
   - Data models (DTOs)
   - Retrofit API client
   - Repository implementation
   - Domain entities + use cases
   - BLoC + states + events
   - UI pages and widgets
4. Add unit tests for use cases and blocs.
5. Register dependencies in `GetIt`.
6. Add route to `AppRouter`.
7. Run `build_runner`.

---

## 📦 Required Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^9.1.1
  equatable: ^2.0.6
  
  # Networking
  dio: ^5.4.0
  retrofit: ^4.7.3
  
  # Navigation
  auto_route: ^10.2.0
  
  # Dependency Injection
  get_it: ^9.0.5
  
  # Functional Programming
  dartz: ^0.10.1
  
  # Code Generation
  json_annotation: ^4.8.1
  
  # Environment
  flutter_dotenv: ^5.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  
  # Code Generators
  build_runner: ^2.4.6
  retrofit_generator: ^10.0.2  
  json_serializable: ^6.7.1
  auto_route_generator: ^10.2.5
  
  # Testing
  mocktail: ^1.0.1
  bloc_test: ^9.1.5
```

---

## ✅ Summary

**Copilot must enforce:**
- Feature-based Clean Architecture.
- Strict layer separation.
- SOLID principles in every class.
- Test coverage for each use case and bloc.
- AutoRoute for navigation.
- GetIt for dependency injection.
- Retrofit for API handling.
- BLoC for presentation logic.

Each feature is isolated, scalable, and ready for enterprise-level Flutter projects.
