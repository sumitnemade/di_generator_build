# DI Generator Build

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
  
  EmailService(this._httpClient, [this._apiKey = 'default-key']);
  
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
  // Get services using generated methods
  final config = getAppConfig(
    apiUrl: 'https://api.example.com',
    apiKey: 'your-api-key',
  );
  
  final client = getHttpClient(); // Automatically gets AppConfig dependency
  final emailService = getEmailService(); // Gets HttpClient dependency automatically
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
