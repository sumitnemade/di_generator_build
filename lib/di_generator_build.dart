/// A dependency injection code generator for Dart/Flutter applications using GetIt.
///
/// This package provides intuitive annotations for automatic dependency injection
/// code generation, making it easy to manage dependencies in your Dart/Flutter applications.
library;

/// ## Features
///
/// - **Intuitive Annotations**: Use clear annotations like @Factory, @Singleton, @LazySingleton
/// - **Automatic Code Generation**: Generates dependency injection methods automatically
/// - **GetIt Integration**: Seamlessly integrates with the GetIt service locator
/// - **Async Support**: Full support for async dependency initialization
/// - **Performance Optimized**: Efficient dependency resolution with GetIt integration
///
/// ## Quick Start
///
/// 1. Add the package to your `pubspec.yaml`:
/// ```yaml
/// dependencies:
///   di_generator_build: ^1.0.0
///
/// dev_dependencies:
///   build_runner: ^2.4.0
/// ```
///
/// 2. Use annotations in your code:
/// ```dart
/// import 'package:di_generator_build/di_generator_build.dart';
///
/// part 'my_service.g.dart';
///
/// @Singleton()
/// class MyService {
///   final Repository _repository;
///
///   MyService(this._repository);
///
///   void doSomething() {
///     // Your service logic
///   }
/// }
/// ```
///
/// 3. Run the code generator:
/// ```bash
/// dart run build_runner build
/// ```
///
/// ## Available Annotations
///
/// ### Synchronous Annotations
/// - **@Factory()**: Creates new instance each time
/// - **@Singleton()**: Creates instance immediately and reuses it
/// - **@LazySingleton()**: Creates instance on first use, then reuses it
/// - **@LazyFactory()**: Alias for LazySingleton (alternative naming)
///
/// ### Asynchronous Annotations
/// - **@AsyncFactory()**: Creates a new async instance each time
/// - **@AsyncSingleton()**: Creates async instance immediately and reuses it
/// - **@AsyncLazySingleton()**: Creates async instance on first use, then reuses it
///
/// ## Examples
///
/// ### Basic Service
/// ```dart
/// @Singleton()
/// class UserService {
///   final UserRepository _repository;
///
///   UserService(this._repository);
///
///   Future<User> getUser(String id) async {
///     return await _repository.findById(id);
///   }
/// }
/// ```
///
/// ### Service with Parameters
/// ```dart
/// @Factory()
/// class EmailService {
///   final String _apiKey;
///   final EmailProvider _provider;
///
///   EmailService(this._provider, [this._apiKey = 'default-key']);
///
///   Future<void> sendEmail(String to, String subject, String body) async {
///     // Email sending logic
///   }
/// }
/// ```
///
/// ### Async Service
/// ```dart
/// @AsyncLazySingleton()
/// class DatabaseService {
///   final String _connectionString;
///   late final Database _database;
///
///   DatabaseService(this._connectionString);
///
///   Future<void> initialize() async {
///     _database = await Database.connect(_connectionString);
///   }
///
///   Future<QueryResult> query(String sql) async {
///     return await _database.execute(sql);
///   }
/// }
/// ```
///
/// ## Generated Code
///
/// The package automatically generates getter methods for each annotated class:
///
/// ```dart
/// // For @Singleton() class UserService
/// UserService getUserService() {
///   return GetIt.instance.getOrRegister<UserService>(
///       () => UserService(getUserRepository()), RegisterAs.singleton);
/// }
///
/// // For @AsyncFactory() class DatabaseService
/// Future<DatabaseService> getDatabaseService({String connectionString = 'default'}) async {
///   return await GetIt.instance.getOrRegisterAsync<DatabaseService>(
///       () async => DatabaseService(connectionString), RegisterAs.factoryAsync);
/// }
/// ```
///
/// ## Contributing
///
/// This package is open source and contributions are welcome! Please see the
/// [GitHub repository](https://github.com/your-username/di_generator_build) for more information.
export 'annotations.dart';
export 'builder.dart';
export 'get_it_extension.dart';
