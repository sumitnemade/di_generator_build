/// A powerful build runner package for automatic dependency injection code generation using GetIt in Flutter applications.
///
/// This package provides:
/// * [AutoRegister] annotation for automatic dependency injection
/// * [GetItExtension] for optimized GetIt operations
/// * [RegisterAs] enum for different registration types
/// * Automatic code generation for dependency injection
///
/// ## Usage
///
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
/// import 'package:get_it/get_it.dart';
///
/// part 'my_service.g.dart';
///
/// @AutoRegister(registrationType: RegisterAs.singleton)
/// class MyService {
///   final Repository _repository;
///   MyService(this._repository);
/// }
/// ```
///
/// ## Features
///
/// * **Single Annotation**: Use `@AutoRegister` for all dependency injection
/// * **Auto Parameter Detection**: Automatically detects constructor parameters
/// * **Smart Dependencies**: Class dependencies are resolved via generated methods
/// * **Named Parameters**: Primitive parameters become named parameters with defaults
/// * **Source Generation**: Generated `.g.dart` files are placed in the source directory
/// * **Multiple Registration Types**: Support for factory, singleton, lazySingleton, and async variants
/// * **Performance Optimized**: Efficient dependency resolution with GetIt integration
library di_generator_build;

// Export the main annotation
export 'annotations.dart';

// Export the builder for build_runner
export 'builder.dart';

// Export the GetIt extension and RegisterAs enum
export 'get_it_extension.dart';
