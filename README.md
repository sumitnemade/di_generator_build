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

## Quick Start

### 1. Add Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  get_it: ^7.6.0

dev_dependencies:
  build_runner: ^2.4.0
  di_generator_build:
    path: ../di_generator_build  # Use path for local development
    # Or use: di_generator_build: ^1.0.0 when published
```

### 2. Use the Annotation

Add `@AutoRegister()` to any class you want to inject:

```dart
import 'package:di_generator_build/di_generator_build.dart';

part 'my_service.g.dart';

@AutoRegister()
class MyService {
  final Repository _repository;
  
  MyService(this._repository);
  
  void doSomething() {
    // Your service logic
  }
}
```

### 3. Generate Code

Run this command to generate the dependency injection code:

```bash
dart run build_runner build
```

### 4. Initialize GetIt and Use the Generated Methods

```dart
import 'package:get_it/get_it.dart';
import 'my_service.dart';

void main() {
  // Initialize GetIt (required)
  final getIt = GetIt.instance;
  
  // Get your service using the generated method
  final service = getMyService();
  service.doSomething();
}
```

## Important Notes

- **GetIt Initialization**: You must initialize GetIt before using generated methods
- **Import Order**: Always import `package:get_it/get_it.dart` in files using generated methods
- **Generated Files**: `.g.dart` files are created automatically in your source directory
- **Build Runner**: Make sure `build_runner` is properly configured

## How It Works

1. **You add `@AutoRegister()` to your class**
2. **The package analyzes your class constructor**
3. **It generates a method that registers your class with GetIt**
4. **The generated method handles all dependencies automatically**

## Registration Types

You can specify how your class should be registered:

```dart
@AutoRegister()                                    // Factory (new instance each time)
@AutoRegister(registrationType: RegisterAs.singleton)        // Singleton (one instance)
@AutoRegister(registrationType: RegisterAs.lazySingleton)    // Lazy singleton (created on first use)
@AutoRegister(registrationType: RegisterAs.factoryAsync)    // Async factory
@AutoRegister(registrationType: RegisterAs.lazySingletonAsync) // Async lazy singleton
@AutoRegister(registrationType: RegisterAs.singletonAsync)   // Async singleton
```

## Roadmap

### Async Registration Types (Coming Soon)

The package currently supports all registration types, including async variants. Here's what's planned for future releases:

#### Phase 1: Basic Async Support ✅
- `RegisterAs.factoryAsync` - Creates async instances each time
- `RegisterAs.lazySingletonAsync` - Creates async instance on first use, then reuses it
- `RegisterAs.singletonAsync` - Creates async instance immediately and reuses it

#### Phase 2: Enhanced Async Features (Planned)
- **Async Parameter Handling**: Support for async constructor parameters
- **Error Handling**: Better async error handling and retry mechanisms
- **Timeout Support**: Configurable timeouts for async operations
- **Async Dependency Resolution**: Automatic handling of async dependencies

#### Phase 3: Advanced Async Patterns (Future)
- **Async Factory Patterns**: More complex async creation logic
- **Async Lifecycle Management**: Better control over async service lifecycles
- **Async Health Checks**: Built-in async service health monitoring

### Current Async Usage

```dart
@AutoRegister(registrationType: RegisterAs.factoryAsync)
class AsyncService {
  final String _name;
  AsyncService(this._name);
  
  Future<void> initialize() async {
    // Async initialization logic
    await Future.delayed(Duration(seconds: 1));
  }
}

// Generated: Future<AsyncService> getAsyncService({String name}) async
// Usage: final service = await getAsyncService(name: 'MyService');
```

## Examples

### Simple Service (No Dependencies)

```dart
@AutoRegister()
class LoggerService {
  void log(String message) => print('LOG: $message');
}

// Generated: LoggerService getLoggerService()
// Usage: final logger = getLoggerService();
```

### Service with Dependencies

```dart
@AutoRegister()
class UserService {
  final Repository _repository;
  UserService(this._repository);
}

// Generated: UserService getUserService() => UserService(getRepository())
// Both UserService and Repository are created when needed
```

### Service with Parameters

```dart
@AutoRegister()
class ConfigService {
  final String _apiKey;
  final int _timeout;
  
  ConfigService([this._apiKey = 'default', this._timeout = 30]);
}

// Generated: ConfigService getConfigService({String apiKey = 'default', int timeout = 30})
```

## Build Commands

```bash
# Generate code once
dart run build_runner build

# Watch for changes during development
dart run build_runner watch

# Clean and rebuild
dart run build_runner clean

# Force rebuild if you have conflicts
dart run build_runner build --delete-conflicting-outputs
```

## Project Structure

After running the build, your project will look like this:

```
lib/
├── services/
│   ├── user_service.dart          # Your service with @AutoRegister
│   ├── user_service.g.dart        # Generated code (auto-created)
│   ├── product_service.dart       # Another service
│   └── product_service.g.dart     # Generated code (auto-created)
├── repositories/
│   ├── user_repository.dart       # Repository with @AutoRegister
│   └── user_repository.g.dart     # Generated code (auto-created)
└── main.dart                      # Use generated methods
```

## Benefits

- **Automatic**: No need to manually write dependency injection code
- **Smart**: Automatically detects constructor parameters and dependencies
- **Fast**: Generates optimized code that works with GetIt
- **Clean**: Follows clean architecture principles
- **Flexible**: Supports different registration types

## Troubleshooting

### Generated files not appearing?
- Check your `build.yaml` configuration
- Run `dart run build_runner clean` then `dart run build_runner build`

### Import errors?
- Make sure you're importing from `package:di_generator_build/di_generator_build.dart`
- Check that the package is in your `dev_dependencies`

### Build errors?
- Run `dart run build_runner build --delete-conflicting-outputs`
- Check that all dependencies are properly installed

## License

This project is licensed under the MIT License.

## Support

If you encounter any issues:
1. Check the troubleshooting section above
2. Look at the example app in the `example/` folder
3. Open an issue on the GitHub repository

---

**Stop writing dependency injection code manually. Let this package do it for you!**
