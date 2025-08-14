// Re-export get_it_extension.dart so users only need to import annotations.dart
export 'get_it_extension.dart';

/// Annotation to mark a class as a factory dependency.
/// 
/// When applied to a class, it will be registered as a factory in GetIt,
/// meaning a new instance will be created each time it's requested.
/// 
/// Example:
/// ```dart
/// @Factory()
/// class MyService {
///   // This class will be registered as a factory
/// }
/// ```
class Factory {
  /// Creates a factory annotation.
  const Factory();
}

/// Annotation to mark a class as a singleton dependency.
/// 
/// When applied to a class, it will be registered as a singleton in GetIt,
/// meaning the same instance will be returned for all requests.
/// 
/// Example:
/// ```dart
/// @Singleton()
/// class MyService {
///   // This class will be registered as a singleton
/// }
/// ```
class Singleton {
  /// Creates a singleton annotation.
  const Singleton();
}

/// Annotation to mark a class as a lazy singleton dependency.
/// 
/// When applied to a class, it will be registered as a lazy singleton in GetIt,
/// meaning the instance will only be created when first requested.
/// 
/// Example:
/// ```dart
/// @LazySingleton()
/// class MyService {
///   // This class will be registered as a lazy singleton
/// }
/// ```
class LazySingleton {
  /// Creates a lazy singleton annotation.
  const LazySingleton();
}

/// Alias for [LazySingleton] for better readability.
/// 
/// This annotation is equivalent to [LazySingleton] and provides
/// an alternative naming convention that some developers prefer.
/// 
/// Example:
/// ```dart
/// @LazyFactory()
/// class MyService {
///   // This class will be registered as a lazy singleton
/// }
/// ```
class LazyFactory {
  /// Creates a lazy factory annotation.
  const LazyFactory();
}

/// Annotation to mark a class as an async factory dependency.
/// 
/// When applied to a class, it will be registered as an async factory in GetIt,
/// meaning an async method will be called to create new instances.
/// 
/// Example:
/// ```dart
/// @AsyncFactory()
/// class MyService {
///   // This class will be registered as an async factory
/// }
/// ```
class AsyncFactory {
  /// Creates an async factory annotation.
  const AsyncFactory();
}

/// Annotation to mark a class as an async singleton dependency.
/// 
/// When applied to a class, it will be registered as an async singleton in GetIt,
/// meaning an async method will be called to create the instance once.
/// 
/// Example:
/// ```dart
/// @AsyncSingleton()
/// class MyService {
///   // This class will be registered as an async singleton
/// }
/// ```
class AsyncSingleton {
  /// Creates an async singleton annotation.
  const AsyncSingleton();
}

/// Annotation to mark a class as an async lazy singleton dependency.
/// 
/// When applied to a class, it will be registered as an async lazy singleton in GetIt,
/// meaning an async method will be called to create the instance when first requested.
/// 
/// Example:
/// ```dart
/// @AsyncLazySingleton()
/// class MyService {
///   // This class will be registered as an async lazy singleton
/// }
/// ```
class AsyncLazySingleton {
  /// Creates an async lazy singleton annotation.
  const AsyncLazySingleton();
}
