# DI Generator Build

[![Pub Version](https://img.shields.io/pub/v/di_generator_build)](https://pub.dev/packages/di_generator_build)
[![Dart Version](https://img.shields.io/badge/dart-3.2.3+-blue.svg)](https://dart.dev/)
[![Flutter Version](https://img.shields.io/badge/flutter-3.16.0+-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/sumitnemade/di_generator_build)
[![Code Coverage](https://img.shields.io/badge/coverage-95%25-brightgreen.svg)](https://github.com/sumitnemade/di_generator_build)
[![Issues](https://img.shields.io/badge/issues-welcome-orange.svg)](https://github.com/sumitnemade/di_generator_build/issues)

[![Dependency Injection](https://img.shields.io/badge/dependency--injection-automatic-blue.svg)](https://pub.dev/packages/di_generator_build)
[![Code Generation](https://img.shields.io/badge/code--generation-automatic-green.svg)](https://pub.dev/packages/di_generator_build)
[![GetIt Integration](https://img.shields.io/badge/getit-integration-purple.svg)](https://pub.dev/packages/get_it)
[![Async Support](https://img.shields.io/badge/async-support-yellow.svg)](https://pub.dev/packages/di_generator_build)
[![Lazy Loading](https://img.shields.io/badge/lazy--loading-enabled-brightgreen.svg)](https://pub.dev/packages/di_generator_build)
[![Performance](https://img.shields.io/badge/performance-optimized-orange.svg)](https://pub.dev/packages/di_generator_build)

A Flutter package that automatically generates dependency injection code for your classes using GetIt.

## What This Package Does

This package automatically creates dependency injection methods for any class you mark with the `@AutoRegister` annotation. It generates `.g.dart` files that contain methods to register and retrieve your classes from GetIt.

**Key Benefit: Dependencies are only created and registered when you actually need them, not at startup!**

## How Lazy Loading Works

### Traditional Dependency Injection (Eager Loading):
```dart
void main() {
  // ❌ All services created immediately at startup
  registerUserService();     // Creates UserService now
  registerProductService();  // Creates ProductService now  
  registerPaymentService();  // Creates PaymentService now
  // App starts slow, uses more memory from the beginning
}
```

### With This Package (Lazy Loading):
```dart
void main() {
  // ✅ No services created at startup - fast startup!
  // Services exist only when you actually request them
}

void showUserProfile() {
  // Only now is UserService created and registered
  final userService = getUserService(); // Created on-demand! 🎯
  // ProductService and PaymentService still don't exist
}

void showProducts() {
  // Only now is ProductService created and registered
  final productService = getProductService(); // Created on-demand! 🎯
}
```

## Benefits of Lazy Loading

- **🚀 Faster App Startup**: No waiting for unused services to initialize
- **💾 Memory Efficient**: Services exist only when needed
- **🎯 On-Demand Creation**: Dependencies created exactly when required
- **⚡ Better Performance**: App feels snappy and responsive
- **🔄 Smart Resource Management**: Resources allocated only when necessary

## ✨ Features

- **Intuitive Annotations**: Use clear annotations like `@Factory`, `@Singleton`, `@LazySingleton`
- **Automatic Code Generation**: Generates dependency injection methods automatically
- **GetIt Integration**: Seamlessly integrates with the GetIt service locator
- **Async Support**: Full support for async dependency initialization
- **Performance Optimized**: Efficient dependency resolution with GetIt integration

## 🚀 Quick Start

### 1. Add Dependencies

Add to your `pubspec.yaml`:

```yaml
dependencies:
  get_it: ^7.6.0
  di_generator_build: ^1.3.0

dev_dependencies:
  build_runner: ^2.5.4
```

### 2. Annotate Your Classes

```dart
import 'package:di_generator_build/annotations.dart';

@RegisterSingleton()
class AppConfig {
  final String apiUrl;
  final String apiKey;
  
  AppConfig({required this.apiUrl, required this.apiKey});
}

@RegisterLazySingleton()
class HttpClient {
  final AppConfig _config;
  
  HttpClient(this._config);
  
  Future<String> get(String url) async {
    // HTTP client implementation
  }
}

@RegisterFactory()
class EmailService {
  final HttpClient _httpClient;
  final String _apiKey;
  
  EmailService(this._httpClient, {required String apiKey});
  
  Future<void> sendEmail(String to, String subject, String body) async {
    // Email sending logic
  }
}
```

### 3. Generate Code

Run the code generator:

```bash
dart run build_runner build
```

### 4. Use Generated Methods

```dart
import 'your_file.g.dart';

void main() {
  // Get services using generated methods (no parameters needed)
  final config = getConfigService();
  final client = getNetworkService(); // Automatically gets ConfigService dependency
  final authService = getAuthService(); // Gets NetworkService dependency automatically
}
```

## 📋 Available Annotations

### Synchronous Annotations

- **@RegisterFactory()**: Creates new instance each time
- **@RegisterSingleton()**: Creates instance immediately and reuses it  
- **@RegisterLazySingleton()**: Creates instance on first use, then reuses it

### Asynchronous Annotations

- **@RegisterAsyncFactory()**: Creates new async instance each time
- **@RegisterAsyncSingleton()**: Creates async instance immediately and reuses it
- **@RegisterAsyncLazySingleton()**: Creates async instance on first use, then reuses it

## 🎯 Key Benefits

### Performance Optimization
Lazy singletons create dependencies only when first requested, reducing startup time and memory usage.

### Memory Efficiency
- **Factories**: Create new instances each time (useful for stateless services)
- **Singletons**: Reuse the same instance (useful for stateful services)
- **Lazy Singletons**: Create on first use, then reuse (best of both worlds)

### Async Support
Handle complex initialization scenarios with async support for database connections, API clients, and more.

### Clean Architecture
Separate dependency creation from business logic, making your code more testable and maintainable.

### Automatic Dependency Resolution
Dependencies are automatically injected based on constructor parameters, reducing boilerplate code.

### Cross-File Dependencies
When services depend on each other across different files, import the generated `.g.dart` files in your main application code:

```dart
// In your main.dart or di_setup.dart
import 'services/app_config.g.dart';
import 'services/http_client.g.dart';
import 'services/email_service.g.dart';
// ... import other generated files as needed
```

### Automatic Parameter Handling
The generated methods automatically handle all parameters with sensible defaults:

- **Required parameters**: Use meaningful defaults based on parameter names (e.g., `apiKey` → `"default-api-key"`)
- **Optional parameters**: Use the default values defined in the constructor
- **Dependencies**: Automatically resolved from GetIt service locator

```dart
// No need to pass parameters - everything is handled automatically
final authService = getAuthService(); // Uses default values for apiKey, secretKey, tokenExpiry
final userService = await getUserService(); // All dependencies resolved automatically
```

### Important Note About Cross-File Dependencies
The generated `.g.dart` files are independent and don't automatically import each other. This is by design to keep the package generic. You need to:

1. Import all the necessary `.g.dart` files in your main application code
2. Call the dependency methods with their required parameters before using dependent services
3. The GetIt service locator will handle the dependency resolution

Example:
```dart
// In your main.dart or di_setup.dart
import 'services/config_service.g.dart';
import 'services/network_service.g.dart';
import 'services/auth_service.g.dart';
import 'services/storage_service.g.dart';
import 'services/user_repository.g.dart';
import 'services/user_service.g.dart';
import 'services/notification_service.g.dart';

void main() async {
  // Set up dependencies in the correct order (no parameters needed)
  final config = getConfigService();
  final network = getNetworkService(); // Uses the registered ConfigService
  final auth = getAuthService(); // Uses the registered NetworkService
  final storage = await getStorageService(); // Uses default connection string
  final userRepo = await getUserRepository(); // Uses the registered StorageService
  final userService = await getUserService(); // Uses the registered UserRepository and AuthService
  final notification = await getNotificationService(); // Uses the registered NetworkService
}
```

### Best Practices for Dependency Management

1. **Order Matters**: Always call dependencies before the services that depend on them
2. **Required Parameters**: Provide required parameters when calling factory services
3. **Async Services**: Use `await` for async services
4. **Singleton vs Factory**: Understand when to use each type:
   - **Singleton**: Use for configuration, shared state
   - **Lazy Singleton**: Use for expensive services that should be shared
   - **Factory**: Use for services that need different parameters each time


## 📝 Examples

### Basic Service

```dart
@RegisterSingleton()
class UserService {
  final UserRepository _repository;
  
  UserService(this._repository);
  
  Future<User> getUser(String id) async {
    return await _repository.findById(id);
  }
}
```

### Service with Parameters

```dart
@RegisterFactory()
class EmailService {
  final String _apiKey;
  final EmailProvider _provider;
  
  EmailService(this._provider, [this._apiKey = 'default-key']);
  
  Future<void> sendEmail(String to, String subject, String body) async {
    // Email sending logic
  }
}
```

### Async Service

```dart
@RegisterAsyncLazySingleton()
class DatabaseService {
  final String _connectionString;
  late final Database _database;
  
  DatabaseService(this._connectionString);
  
  Future<void> initialize() async {
    _database = await Database.connect(_connectionString);
  }
  
  Future<QueryResult> query(String sql) async {
    return await _database.execute(sql);
  }
}
```

## 🔄 Generated Code

The package automatically generates getter methods for each annotated class:

```dart
// For @RegisterSingleton() class UserService
UserService getUserService() {
  return GetIt.instance.getOrRegister<UserService>(
      () => UserService(getUserRepository()), RegisterAs.singleton);
}

// For @RegisterAsyncFactory() class DatabaseService
Future<DatabaseService> getDatabaseService({String connectionString = 'default'}) async {
  return await GetIt.instance.getOrRegisterAsync<DatabaseService>(
      () async => DatabaseService(connectionString), RegisterAs.factoryAsync);
}
```

## 🧪 Testing

The generated code integrates seamlessly with GetIt, making it easy to mock dependencies in tests:

```dart
void main() {
  setUp(() {
    // Register mock dependencies
    GetIt.instance.registerSingleton<UserRepository>(MockUserRepository());
  });
  
  tearDown(() {
    GetIt.instance.reset();
  });
  
  test('should get user service', () {
    final userService = getUserService();
    expect(userService, isA<UserService>());
  });
}
```

## 📦 Installation

```bash
dart pub add di_generator_build
dart pub add build_runner --dev
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Clone the repository
2. Install dependencies: `dart pub get`
3. Run tests: `dart test`
4. Make your changes
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built on top of the excellent [GetIt](https://pub.dev/packages/get_it) package
- Uses [build_runner](https://pub.dev/packages/build_runner) for code generation
- [source_gen](https://pub.dev/packages/source_gen): Source code generation utilities

## 📞 Support

If you have any questions or need help, please:

1. Check the [examples](example/) directory
2. Review the [tests](test/) for usage patterns
3. Open an issue on GitHub
4. Check the [documentation](https://pub.dev/packages/di_generator_build)

---

**Happy coding! 🎉**
