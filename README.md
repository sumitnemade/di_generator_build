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
  di_generator_build: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.0
```

### 2. Use Annotations

```dart
import 'package:di_generator_build/di_generator_build.dart';

part 'my_service.g.dart';

@Singleton()
class UserService {
  final UserRepository _repository;
  
  UserService(this._repository);
  
  Future<User> getUser(String id) async {
    return await _repository.findById(id);
  }
}
```

### 3. Run Code Generation

```bash
dart run build_runner build
```

```dart
@LazySingleton()
class HeavyComputationService {
  // This service won't be instantiated until someone calls getHeavyComputationService()
  // Saves memory and startup time
}

@AsyncLazySingleton()
class DatabaseService {
  // Database connection won't be established until first use
  // Useful when you need runtime configuration
}
```

### **Factory & AsyncFactory**
- **New instance created every time**
- **Perfect for services that should not share state**
- **Useful for request-scoped services**

```dart
@Factory()
class RequestLogger {
  // Each request gets its own logger instance
  // No shared state between requests
}
```

### **Singleton & AsyncSingleton**
- **Instance created immediately during registration**
- **Use sparingly - only for services that must be available at startup**
- **Good for configuration objects or lightweight services**

```dart
@Singleton()
class AppConfig {
  // Configuration is loaded immediately
  // Available throughout app lifecycle
}
```

## 🏷️ Available Annotations

### Synchronous Annotations

| Annotation | Description | Use Case |
|------------|-------------|----------|
| `@Factory()` | Creates new instance each time | Services that should not be shared |
| `@Singleton()` | Creates instance immediately and reuses it | Configuration objects, expensive services |
| `@LazySingleton()` | Creates instance on first use, then reuses it | Services with deferred initialization |
| `@LazyFactory()` | Alias for LazySingleton | Alternative naming convention |

### Asynchronous Annotations

| Annotation | Description | Use Case |
|------------|-------------|----------|
| `@AsyncFactory()` | Creates new async instance each time | Async services that should not be shared |
| `@AsyncSingleton()` | Creates async instance immediately and reuses it | Async services with immediate initialization |
| `@AsyncLazySingleton()` | Creates async instance on first use | Async services with deferred initialization |

## 📚 Examples

### Lazy Service (Recommended for most cases)

```dart
@LazySingleton()
class UserService {
  final UserRepository _repository;
  
  UserService(this._repository);
  
  Future<User> getUser(String id) async {
    return await _repository.findById(id);
  }
}

// UserService is only created when first accessed
// Saves memory and startup time
final userService = getUserService();
```

### Service with Parameters

```dart
@Factory()
class EmailService {
  final String _apiKey;
  final EmailProvider _provider;
  
  EmailService(this._provider, [this._apiKey = 'default-key']);
  
  Future<void> sendEmail(String to, String subject, String body) async {
    // Email sending logic
  }
}

// New instance created each time - no shared state
final emailService = getEmailService();
```

### Async Lazy Service (Best for expensive operations)

```dart
@AsyncLazySingleton()
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

// Database connection only established when first needed
// Perfect for services that depend on runtime configuration
final dbService = await getDatabaseService();
```

### Configuration Service (Use sparingly)

```dart
@Singleton()
class AppConfig {
  final String apiUrl;
  final String apiKey;
  final bool debugMode;
  
  AppConfig({
    required this.apiUrl,
    required this.apiKey,
    this.debugMode = false,
  });
}

// Configuration loaded immediately at startup
// Only use for services that must be available immediately
final config = getAppConfig();
```

### Memory-Efficient Service Chain

```dart
@LazySingleton()
class AnalyticsService {
  final DatabaseService _db;
  final CacheService _cache;
  
  AnalyticsService(this._db, this._cache);
  
  Future<void> trackEvent(String event) async {
    // Heavy analytics processing
    // Only created when analytics are actually needed
  }
}

@LazySingleton()
class CacheService {
  // Cache service only initialized when first accessed
  // Saves memory if caching isn't used
}

// Services are created in dependency order only when needed
final analytics = getAnalyticsService();
```

## ⚡ Performance Benefits

### **Memory Optimization**
- **LazySingleton**: Services consume memory only when accessed
- **Factory**: No shared instances, perfect for request-scoped operations
- **AsyncLazySingleton**: Expensive async operations deferred until needed

### **Startup Time Improvement**
- **No expensive initialization during app startup**
- **Dependencies created on-demand**
- **Faster app launch, especially for complex applications**

### **Resource Management**
- **Database connections only established when needed**
- **Heavy computations deferred until required**
- **Network services initialized on first use**

### **Best Practices for Performance**

```dart
// ✅ Good: Use LazySingleton for expensive services
@LazySingleton()
class ImageProcessingService {
  // Heavy image processing libraries loaded only when needed
}

// ✅ Good: Use Factory for stateless services
@Factory()
class LoggingService {
  // New instance each time, no shared state
}

// ⚠️ Use sparingly: Singleton for essential services only
@Singleton()
class AppConfig {
  // Only for services that must be available immediately
}

// ❌ Avoid: Don't use Singleton for expensive services
// @Singleton() // This loads immediately at startup
// class HeavyService { ... }
```

## 🔧 Generated Code

The package automatically generates getter methods for each annotated class:

```dart
// For @Singleton() class UserService
UserService getUserService() {
  return GetIt.instance.getOrRegister<UserService>(
      () => UserService(getUserRepository()), RegisterAs.singleton);
}

// For @AsyncFactory() class DatabaseService
Future<DatabaseService> getDatabaseService({String connectionString = 'default'}) async {
  return await GetIt.instance.getOrRegisterAsync<DatabaseService>(
      () async => DatabaseService(connectionString), RegisterAs.factoryAsync);
}
```

## 🏗️ Architecture

The package follows clean architecture principles and provides:

- **Annotation Layer**: Intuitive annotations for dependency injection
- **Code Generation**: Automatic generation of DI methods using build_runner
- **GetIt Integration**: Seamless integration with GetIt service locator
- **Async Support**: Full support for async dependency initialization
- **Performance Optimization**: Efficient dependency resolution

## 📁 Project Structure

```
lib/
├── annotations.dart          # Dependency injection annotations
├── builder.dart             # Code generation logic
├── get_it_extension.dart    # GetIt extensions
└── di_generator_build.dart  # Main library exports

example/
├── example.dart             # Comprehensive usage examples
└── example.g.dart          # Generated code (after build)

test/
└── di_generator_build_test.dart  # Unit tests
```

## 🧪 Testing

Run the tests:

```bash
dart test
```

## 🔍 Code Generation

The package uses `build_runner` for code generation. Generated files are placed alongside source files for better developer experience.

### Build Commands

```bash
# Generate code once
dart run build_runner build

# Watch for changes and generate automatically
dart run build_runner watch

# Clean generated files
dart run build_runner clean
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

## 📞 Support

If you have any questions or need help, please:

1. Check the [examples](example/) directory
2. Review the [tests](test/) for usage patterns
3. Open an issue on GitHub
4. Check the [documentation](https://pub.dev/packages/di_generator_build)

---

**Happy coding! 🎉**
