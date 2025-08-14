/// A powerful build runner package for automatic dependency injection code generation using GetIt in Flutter applications.
///
/// This package provides a comprehensive solution for automatic dependency injection
/// by analyzing your code and generating the necessary GetIt registration code.
/// It supports various registration patterns including factories, singletons, and lazy singletons,
/// with both synchronous and asynchronous initialization.
///
/// ## Quick Start
///
/// 1. Add the package to your `pubspec.yaml`:
/// ```yaml
/// dev_dependencies:
///   di_generator_build: ^1.2.0
///   build_runner: ^2.5.4
/// ```
///
/// 2. Annotate your classes:
/// ```dart
/// import 'package:di_generator_build/annotations.dart';
///
/// @RegisterSingleton()
/// class AppConfig {
///   final String apiUrl;
///   AppConfig({required this.apiUrl});
/// }
///
/// @RegisterLazySingleton()
/// class HttpClient {
///   final AppConfig _config;
///   HttpClient(this._config);
/// }
/// ```
///
/// 3. Run the code generator:
/// ```bash
/// dart run build_runner build
/// ```
///
/// 4. Use the generated methods:
/// ```dart
/// import 'your_file.g.dart';
///
/// void main() {
///   final config = getAppConfig(apiUrl: 'https://api.example.com');
///   final client = getHttpClient(); // Automatically gets AppConfig dependency
/// }
/// ```
///
/// ## Available Annotations
///
/// - **@RegisterFactory()**: Creates new instance each time
/// - **@RegisterSingleton()**: Creates instance immediately and reuses it
/// - **@RegisterLazySingleton()**: Creates instance on first use, then reuses it
/// - **@RegisterAsyncFactory()**: Creates new async instance each time
/// - **@RegisterAsyncSingleton()**: Creates async instance immediately and reuses it
/// - **@RegisterAsyncLazySingleton()**: Creates async instance on first use, then reuses it
///
/// ## Features
///
/// - **Automatic dependency resolution**: Dependencies are automatically injected
/// - **Lazy loading**: Optimize performance by creating dependencies only when needed
/// - **Async support**: Handle asynchronous dependency creation and resolution
/// - **Type safety**: Full type safety with Dart's static analysis
/// - **GetIt integration**: Seamless integration with the GetIt service locator
/// - **Build-time generation**: No runtime overhead, all code generated at build time
///
/// ## Benefits
///
/// - **Performance optimization**: Lazy singletons create dependencies only when first requested
/// - **Memory efficiency**: Factories create new instances each time, singletons reuse instances
/// - **Async initialization**: Handle complex initialization scenarios with async support
/// - **Clean architecture**: Separate dependency creation from business logic
/// - **Testability**: Easy to mock and test with dependency injection
///
/// ## Configuration
///
/// Add to your `build.yaml`:
/// ```yaml
/// targets:
///   $default:
///     builders:
///       di_generator_build|di_generator:
///         enabled: true
/// ```
///
/// ## Example
///
/// See the `example/` directory for a complete working example.
library;

export 'annotations.dart';
export 'builder.dart';
export 'get_it_extension.dart';
