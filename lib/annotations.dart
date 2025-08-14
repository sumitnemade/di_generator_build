import 'get_it_extension.dart';

// Re-export get_it_extension.dart so users only need to import annotations.dart
export 'get_it_extension.dart';

/// Factory annotation - creates a new instance each time.
///
/// This annotation will automatically generate a method that registers the class with GetIt
/// as a factory, creating a new instance every time it's requested.
///
/// ## Usage
///
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
/// import 'package:get_it/get_it.dart';
///
/// part 'my_service.g.dart';
///
/// @Factory()
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///   
///   MyService(this._repository, [this._apiKey = 'default-key']);
///   
///   void doSomething() {
///     // Your service logic
///   }
/// }
/// ```
///
/// ## Generated Code
///
/// The annotation will generate:
///
/// ```dart
/// MyService getMyService({String apiKey = 'default-key'}) {
///   return GetIt.instance.getOrRegister<MyService>(
///       () => MyService(getRepository(), apiKey), RegisterAs.factory);
/// }
/// ```
class Factory {
  /// Creates a Factory annotation.
  const Factory();
}

/// Singleton annotation - creates instance immediately and reuses it.
///
/// This annotation will automatically generate a method that registers the class with GetIt
/// as a singleton, creating the instance immediately and reusing it for all subsequent requests.
///
/// ## Usage
///
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
/// import 'package:get_it/get_it.dart';
///
/// part 'my_service.g.dart';
///
/// @Singleton()
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///   
///   MyService(this._repository, [this._apiKey = 'default-key']);
///   
///   void doSomething() {
///     // Your service logic
///   }
/// }
/// ```
///
/// ## Generated Code
///
/// The annotation will generate:
///
/// ```dart
/// MyService getMyService({String apiKey = 'default-key'}) {
///   return GetIt.instance.getOrRegister<MyService>(
///       () => MyService(getRepository(), apiKey), RegisterAs.singleton);
/// }
/// ```
class Singleton {
  /// Creates a Singleton annotation.
  const Singleton();
}

/// LazySingleton annotation - creates instance on first use, then reuses it.
///
/// This annotation will automatically generate a method that registers the class with GetIt
/// as a lazy singleton, creating the instance only when first needed and then reusing it.
///
/// ## Usage
///
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
/// import 'package:get_it/get_it.dart';
///
/// part 'my_service.g.dart';
///
/// @LazySingleton()
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///   
///   MyService(this._repository, [this._apiKey = 'default-key']);
///   
///   void doSomething() {
///     // Your service logic
///   }
/// }
/// ```
///
/// ## Generated Code
///
/// The annotation will generate:
///
/// ```dart
/// MyService getMyService({String apiKey = 'default-key'}) {
///   return GetIt.instance.getOrRegister<MyService>(
///       () => MyService(getRepository(), apiKey), RegisterAs.lazySingleton);
/// }
/// ```
class LazySingleton {
  /// Creates a LazySingleton annotation.
  const LazySingleton();
}

/// LazyFactory annotation - creates instance on first use, then reuses it (alias for LazySingleton).
///
/// This annotation is an alias for LazySingleton, providing an alternative naming convention.
///
/// ## Usage
///
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
/// import 'package:get_it/get_it.dart';
///
/// part 'my_service.g.dart';
///
/// @LazyFactory()
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///   
///   MyService(this._repository, [this._apiKey = 'default-key']);
///   
///   void doSomething() {
///     // Your service logic
///   }
/// }
/// ```
///
/// ## Generated Code
///
/// The annotation will generate:
///
/// ```dart
/// MyService getMyService({String apiKey = 'default-key'}) {
///       () => MyService(getRepository(), apiKey), RegisterAs.lazySingleton);
/// }
/// ```
class LazyFactory {
  /// Creates a LazyFactory annotation.
  const LazyFactory();
}

/// AsyncFactory annotation - creates a new async instance each time.
///
/// This annotation will automatically generate a method that registers the class with GetIt
/// as an async factory, creating a new async instance every time it's requested.
///
/// ## Usage
///
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
/// import 'package:get_it/get_it.dart';
///
/// part 'my_service.g.dart';
///
/// @AsyncFactory()
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///   
///   MyService(this._repository, [this._apiKey = 'default-key']);
///   
///   Future<void> doSomething() async {
///     // Your async service logic
///   }
/// }
/// ```
///
/// ## Generated Code
///
/// The annotation will generate:
///
/// ```dart
/// Future<MyService> getMyService({String apiKey = 'default-key'}) async {
///   return await GetIt.instance.getOrRegisterAsync<MyService>(
///       () async => MyService(getRepository(), apiKey), RegisterAs.factoryAsync);
/// }
/// ```
class AsyncFactory {
  /// Creates an AsyncFactory annotation.
  const AsyncFactory();
}

/// AsyncSingleton annotation - creates async instance immediately and reuses it.
///
/// This annotation will automatically generate a method that registers the class with GetIt
/// as an async singleton, creating the async instance immediately and reusing it.
///
/// ## Usage
///
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
/// import 'package:get_it/get_it.dart';
///
/// part 'my_service.g.dart';
///
/// @Singleton()
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///   
///   MyService(this._repository, [this._apiKey = 'default-key']);
///   
///   Future<void> doSomething() async {
///     // Your async service logic
///   }
/// }
/// ```
///
/// ## Generated Code
///
/// The annotation will generate:
///
/// ```dart
/// Future<MyService> getMyService({String apiKey = 'default-key'}) async {
///   return await GetIt.instance.getOrRegisterAsync<MyService>(
///       () async => MyService(getRepository(), apiKey), RegisterAs.singletonAsync);
/// }
/// ```
class AsyncSingleton {
  /// Creates an AsyncSingleton annotation.
  const AsyncSingleton();
}

/// AsyncLazySingleton annotation - creates async instance on first use, then reuses it.
///
/// This annotation will automatically generate a method that registers the class with GetIt
/// as an async lazy singleton, creating the async instance only when first needed.
///
/// ## Usage
///
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
/// import 'package:get_it/get_it.dart';
///
/// part 'my_service.g.dart';
///
/// @AsyncLazySingleton()
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///   
///   MyService(this._repository, [this._apiKey = 'default-key']);
///   
///   Future<void> doSomething() async {
///     // Your async service logic
///   }
/// }
/// ```
///
/// ## Generated Code
///
/// The annotation will generate:
///
/// ```dart
/// Future<MyService> getMyService({String apiKey = 'default-key'}) async {
///   return await GetIt.instance.getOrRegisterAsync<MyService>(
///       () async => MyService(getRepository(), apiKey), RegisterAs.lazySingletonAsync);
/// }
/// ```
class AsyncLazySingleton {
  /// Creates an AsyncLazySingleton annotation.
  const AsyncLazySingleton();
}
