import 'get_it_extension.dart';

// Re-export get_it_extension.dart so users only need to import annotations.dart
export 'get_it_extension.dart';

/// Annotation to mark a class for dependency injection generation.
///
/// This annotation will automatically generate a method that registers the class with GetIt.
/// Constructor parameters are automatically detected and handled.
///
/// ## Usage
///
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
/// import 'package:get_it/get_it.dart';
///
/// part 'my_service.g.dart';
///
/// @AutoRegister(
///   registrationType: RegisterAs.singleton,
/// )
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
///
/// ## Registration Types
///
/// - [RegisterAs.factory]: Creates a new instance each time
/// - [RegisterAs.singleton]: Creates instance immediately and reuses it
/// - [RegisterAs.lazySingleton]: Creates instance on first use, then reuses it
/// - [RegisterAs.factoryAsync]: Creates async instance each time
/// - [RegisterAs.lazySingletonAsync]: Creates async instance on first use, then reuses it
/// - [RegisterAs.singletonAsync]: Creates async instance immediately and reuses it
class AutoRegister {

  /// Creates an AutoRegister annotation.
  ///
  /// [registrationType] defaults to [RegisterAs.factory] if not specified.
  const AutoRegister({
    this.registrationType = RegisterAs.factory,
  });
  /// The registration type (factory, singleton, lazySingleton, etc.)
  final RegisterAs registrationType;
}
