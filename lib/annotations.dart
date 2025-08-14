// Re-export get_it_extension.dart so users only need to import annotations.dart
export 'get_it_extension.dart';

/// Annotation to mark a class for automatic factory registration in GetIt.
///
/// When applied to a class, it will be registered as a factory in GetIt,
/// meaning a new instance will be created each time it's requested.
///
/// Example:
/// ```dart
/// @RegisterFactory()
/// class MyService {
///   // This class will be registered as a factory
/// }
/// ```
class RegisterFactory {
  /// Creates a factory registration annotation.
  const RegisterFactory();
}

/// Annotation to mark a class for automatic singleton registration in GetIt.
///
/// When applied to a class, it will be registered as a singleton in GetIt,
/// meaning the same instance will be returned for all requests.
///
/// Example:
/// ```dart
/// @RegisterSingleton()
/// class MyService {
///   // This class will be registered as a singleton
/// }
/// ```
class RegisterSingleton {
  /// Creates a singleton registration annotation.
  const RegisterSingleton();
}

/// Annotation to mark a class for automatic lazy singleton registration in GetIt.
///
/// When applied to a class, it will be registered as a lazy singleton in GetIt,
/// meaning the instance will only be created when first requested.
///
/// Example:
/// ```dart
/// @RegisterLazySingleton()
/// class MyService {
///   // This class will be registered as a lazy singleton
/// }
/// ```
class RegisterLazySingleton {
  /// Creates a lazy singleton registration annotation.
  const RegisterLazySingleton();
}

/// Annotation to mark a class for automatic async factory registration in GetIt.
///
/// When applied to a class, it will be registered as an async factory in GetIt,
/// meaning an async method will be called to create new instances.
///
/// Example:
/// ```dart
/// @RegisterAsyncFactory()
/// class MyService {
///   // This class will be registered as an async factory
/// }
/// ```
class RegisterAsyncFactory {
  /// Creates an async factory registration annotation.
  const RegisterAsyncFactory();
}

/// Annotation to mark a class for automatic async singleton registration in GetIt.
///
/// When applied to a class, it will be registered as an async singleton in GetIt,
/// meaning an async method will be called to create the instance once.
///
/// Example:
/// ```dart
/// @RegisterAsyncSingleton()
/// class MyService {
///   // This class will be registered as an async singleton
/// }
/// ```
class RegisterAsyncSingleton {
  /// Creates an async singleton registration annotation.
  const RegisterAsyncSingleton();
}

/// Annotation to mark a class for automatic async lazy singleton registration in GetIt.
///
/// When applied to a class, it will be registered as an async lazy singleton in GetIt,
/// meaning an async method will be called to create the instance when first requested.
///
/// Example:
/// ```dart
/// @RegisterAsyncLazySingleton()
/// class MyService {
///   // This class will be registered as an async lazy singleton
/// }
/// ```
class RegisterAsyncLazySingleton {
  /// Creates an async lazy singleton registration annotation.
  const RegisterAsyncLazySingleton();
}
