# Template App - Flutter Clean Architecture

A production-ready Flutter template implementing **Clean Architecture**, **BLoC pattern**, and **SOLID principles** with a complete Login → Home → Detail flow.

## 🎯 Features

- ✅ **Feature-based Clean Architecture** (Domain, Data, Presentation layers)
- ✅ **BLoC State Management** with composition-based states
- ✅ **Dependency Injection** with GetIt
- ✅ **API Integration** with Retrofit + Dio
- ✅ **Type-safe Navigation** with AutoRoute
- ✅ **Error Handling** with Dartz (Either pattern)
- ✅ **Environment Configuration** (dev/prod)
- ✅ **Unit Tests** for UseCases and BLoCs (using mocktail & bloc_test)

## 🏗️ Architecture

```
lib/
├── core/                    # Shared infrastructure
│   ├── config/             # Environment configuration
│   ├── error/              # Failures & Exceptions
│   ├── network/            # Dio client with interceptors
│   └── router/             # AutoRoute configuration
├── features/                # Feature modules (isolated)
│   ├── login/              # Authentication feature
│   ├── home/               # Pokémon list feature
│   └── detail/             # Pokémon detail feature
├── injection/              # GetIt dependency injection
└── main.dart
```

## 🚀 Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Run the App
```bash
# Development environment (default)
flutter run

# Production environment
flutter run --dart-define=ENV=prod
```

### 4. Run Tests
```bash
flutter test

# With coverage
flutter test --coverage
```

## 🔐 Login Credentials

The app uses [DummyJSON API](https://dummyjson.com/) for authentication.

**Test credentials:**
- Username: `emilys`
- Password: `emilyspass`

[See more users →](https://dummyjson.com/users)

## 📱 App Flow

1. **Login Page** → Authenticate with DummyJSON API
2. **Home Page** → View list of Pokémon (from PokéAPI)
3. **Detail Page** → View detailed Pokémon information

## 🧪 Testing Strategy

The template includes comprehensive tests:

- **UseCase Tests**: Pure Dart unit tests with mocked repositories
- **BLoC Tests**: Using `bloc_test` package for state verification
- **Test Helpers**: Shared mocks and fixtures in `test/helpers/`

Example test run:
```bash
flutter test
# Output: 00:04 +8: All tests passed!
```

## 🛠️ Development Commands

```bash
# Code generation (watch mode)
flutter pub run build_runner watch --delete-conflicting-outputs

# Static analysis
flutter analyze

# Format code
dart format lib test -l 80

# Build APK (production)
flutter build apk --dart-define=ENV=prod

# Build iOS (production)
flutter build ios --dart-define=ENV=prod
```

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `dio` + `retrofit` | HTTP client & API integration |
| `auto_route` | Type-safe navigation |
| `get_it` | Dependency injection |
| `dartz` | Functional programming (Either) |
| `equatable` | Value equality |
| `mocktail` + `bloc_test` | Testing |

## 🌐 APIs Used

- **Auth API**: https://dummyjson.com/auth/login
- **Pokémon API**: https://pokeapi.co/api/v2

## 📚 Project Structure Highlights

### Each feature follows Clean Architecture:

```
features/login/
├── data/
│   ├── datasources/        # Retrofit API clients
│   ├── models/             # JSON serializable DTOs
│   └── repositories/       # Repository implementations
├── domain/
│   ├── entities/           # Pure Dart business objects
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic
└── presentation/
    ├── bloc/               # BLoC (events, states, bloc)
    ├── pages/              # Screen widgets
    └── widgets/            # Reusable UI components
```

### State Management Pattern

Using **composition over inheritance** for BLoC states:

```dart
class LoginState extends Equatable {
  final bool isLoading;
  final User? user;
  final Failure? failure;
  
  // Helper methods: toLoading(), toSuccess(), toError()
}
```

## 🎨 UI Features

- Material Design 3
- Loading states with CircularProgressIndicator
- Error handling with retry buttons
- Form validation
- Snackbar notifications
- Image loading with error fallback
- Responsive layouts

## 📝 Notes

- **Platforms**: Android and iOS only
- **Minimum Flutter version**: 3.9.2+
- All generated files (*.g.dart, *.gr.dart) are gitignored
- Run `build_runner` after pulling changes that modify models/APIs

## 🤝 Contributing

This is a template project. Feel free to:
- Add more features following the same architecture
- Extend test coverage
- Improve UI/UX
- Add more environment configurations

## 📄 License

This template is free to use for any purpose.

---

**Built with** ❤️ **following Clean Architecture principles**
