import 'package:get_it/get_it.dart';

/// Extension on GetIt to provide optimized lazy loading functionality.
///
/// This extension provides convenient methods for getting or registering dependencies
/// with GetIt, ensuring optimal performance and clean dependency management.
///
/// ## Usage
///
/// ```dart
/// import 'package:get_it/get_it.dart';
/// import 'package:di_generator_build/di_generator_build.dart';
///
/// final getIt = GetIt.instance;
///
/// // Register a service
/// getIt.getOrRegister<MyService>(() => MyService(), RegisterAs.singleton);
///
/// // Get the service (will be created if not registered)
/// final service = getIt.get<MyService>();
/// ```
extension GetItExtension on GetIt {
  /// Gets or registers a dependency with optimized lazy loading.
  ///
  /// This method checks if a dependency is already registered and either returns
  /// the existing instance or registers a new one based on the specified type.
  ///
  /// [instanceCreator] - Function that creates the instance
  /// [registerAs] - Type of registration (factory, singleton, lazySingleton, etc.)
  ///
  /// Returns the dependency instance.
  T getOrRegister<T extends Object>(
    T Function() instanceCreator,
    RegisterAs registerAs,
  ) {
    // Optimized: Check registration once and handle accordingly
    if (!isRegistered<T>()) {
      switch (registerAs) {
        case RegisterAs.singleton:
          // Optimized: Create instance once and register
          registerSingleton<T>(instanceCreator());
          break;
        case RegisterAs.factory:
          // Optimized: Direct function registration without extra wrapping
          registerFactory<T>(instanceCreator);
          break;
        case RegisterAs.lazySingleton:
          // Optimized: Direct function registration without extra wrapping
          registerLazySingleton<T>(instanceCreator);
          break;
        default:
          throw UnimplementedError('RegisterAs.$registerAs is not implemented');
        // case RegisterAs.factoryAsync:
        //   // Async factory registration
        //   registerFactoryAsync<T>(() async => instanceCreator());
        //   break;
        // case RegisterAs.lazySingletonAsync:
        //   // Async lazy singleton registration
        //   registerLazySingletonAsync<T>(() async => instanceCreator());
        //   break;
        // case RegisterAs.singletonAsync:
        //   // Async singleton registration
        //   registerSingletonAsync<T>(() async => instanceCreator());
        //   break;
      }
    }

    return get<T>();
  }

  /// Optimized method for factory registration (most common use case).
  ///
  /// Creates a new instance each time the dependency is requested.
  T getOrRegisterFactory<T extends Object>(T Function() instanceCreator) =>
      getOrRegister<T>(instanceCreator, RegisterAs.factory);

  /// Optimized method for lazy singleton registration.
  ///
  /// Creates the instance on first use, then reuses it for subsequent requests.
  T getOrRegisterLazySingleton<T extends Object>(
          T Function() instanceCreator) =>
      getOrRegister<T>(instanceCreator, RegisterAs.lazySingleton);

  /// Optimized method for singleton registration.
  ///
  /// Creates the instance immediately and reuses it for all subsequent requests.
  T getOrRegisterSingleton<T extends Object>(T Function() instanceCreator) =>
      getOrRegister<T>(instanceCreator, RegisterAs.singleton);

  /// Optimized method for async factory registration.
  ///
  /// Creates a new async instance each time the dependency is requested.
// Future<T> getOrRegisterFactoryAsync<T extends Object>(
//     Future<T> Function() instanceCreator) {
//   if (!isRegistered<T>()) {
//     registerFactoryAsync<T>(instanceCreator);
//   }
//
//   return getAsync<T>();
// }

  /// Optimized method for async lazy singleton registration.
  ///
  /// Creates the async instance on first use, then reuses it for subsequent requests.
// Future<T> getOrRegisterLazySingletonAsync<T extends Object>(
//     Future<T> Function() instanceCreator) {
//   if (!isRegistered<T>()) {
//     registerLazySingletonAsync<T>(instanceCreator);
//   }
//
//   return getAsync<T>();
// }
//
// /// Optimized method for async singleton registration.
// ///
// /// Creates the async instance immediately and reuses it for all subsequent requests.
// Future<T> getOrRegisterSingletonAsync<T extends Object>(
//     Future<T> Function() instanceCreator) {
//   if (!isRegistered<T>()) {
//     registerSingletonAsync<T>(instanceCreator);
//   }
//
//   return getAsync<T>();
// }
}

/// Enum to specify the type of dependency registration.
///
/// This enum defines all possible ways to register dependencies with GetIt,
/// providing flexibility for different use cases and performance requirements.
enum RegisterAs {
  /// Creates instance immediately and reuses it.
  ///
  /// Use this when you want the instance to be created right away and shared
  /// across all consumers. Good for configuration objects or services that
  /// are expensive to create but cheap to use.
  singleton,

  /// Creates new instance each time.
  ///
  /// Use this when you need a fresh instance every time. Good for objects
  /// that should not be shared or have state that changes between uses.
  factory,

  /// Creates instance on first use, then reuses it.
  ///
  /// Use this when you want the instance to be created only when first needed
  /// and then shared. Good for services that are expensive to create but
  /// you want to defer the creation cost.
  lazySingleton,

  /// Creates async instance each time.
  ///
  /// Use this when you need a new async instance every time. Good for
  /// objects that require async initialization and should not be shared.
  factoryAsync,

  /// Creates async instance on first use, then reuses it.
  ///
  /// Use this when you want the async instance to be created only when first
  /// needed and then shared. Good for services that require async initialization
  /// but you want to defer the creation cost.
  lazySingletonAsync,

  /// Creates async instance immediately and reuses it.
  ///
  /// Use this when you want the async instance to be created right away and
  /// shared across all consumers. Good for services that require async
  /// initialization and are expensive to create but cheap to use.
  singletonAsync,
}
