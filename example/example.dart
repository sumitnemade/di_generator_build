/// Example demonstrating the usage of di_generator_build package with dependency injection annotations.
///
/// This example shows how to use the new dependency injection annotations (@Factory, @Singleton, @LazySingleton, etc.)
/// for dependency injection in Dart/Flutter applications.
///
/// Run the code generator to see the generated code:
/// ```bash
/// dart run build_runner build
/// ```

import 'package:di_generator_build/di_generator_build.dart';
import 'package:get_it/get_it.dart';

// Import the generated part file
part 'example.g.dart';

// Example repository interface
abstract class UserRepository {
  Future<User> findById(String id);
  Future<List<User>> findAll();
}

// Example user model
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  @override
  String toString() => 'User(id: $id, name: $name, email: $email)';
}

// Example configuration service - Singleton for app-wide configuration
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

  @override
  String toString() => 'AppConfig(apiUrl: $apiUrl, apiKey: $apiKey, debugMode: $debugMode)';
}

// Example HTTP client service - LazySingleton for network operations
@LazySingleton()
class HttpClient {
  final AppConfig _config;

  HttpClient(this._config);

  Future<String> get(String url) async {
    // Simulate HTTP request
    await Future.delayed(Duration(milliseconds: 100));
    return 'Response from $url';
  }

  @override
  String toString() => 'HttpClient(config: $_config)';
}

// Example database service - AsyncLazySingleton for database connections
@AsyncLazySingleton()
class DatabaseService {
  final String _connectionString;
  late final String _connection;

  DatabaseService(this._connectionString);

  Future<void> initialize() async {
    // Simulate database connection
    await Future.delayed(Duration(milliseconds: 200));
    _connection = 'Connected to $_connectionString';
  }

  Future<String> query(String sql) async {
    // Simulate database query
    await Future.delayed(Duration(milliseconds: 50));
    return 'Result: $sql';
  }

  @override
  String toString() => 'DatabaseService(connection: $_connection)';
}

// Example email service - Factory for email operations (new instance each time)
@Factory()
class EmailService {
  final HttpClient _httpClient;
  final String _apiKey;

  EmailService(this._httpClient, [this._apiKey = 'default-key']);

  Future<void> sendEmail(String to, String subject, String body) async {
    // Simulate email sending
    await Future.delayed(Duration(milliseconds: 150));
    print('Email sent to $to: $subject');
  }

  @override
  String toString() => 'EmailService(httpClient: $_httpClient, apiKey: $_apiKey)';
}

// Example notification service - AsyncFactory for notifications (new async instance each time)
@AsyncFactory()
class NotificationService {
  final String _deviceToken;
  final HttpClient _httpClient;

  NotificationService(this._deviceToken, this._httpClient);

  Future<void> sendNotification(String title, String body) async {
    // Simulate notification sending
    await Future.delayed(Duration(milliseconds: 100));
    print('Notification sent to $_deviceToken: $title - $body');
  }

  @override
  String toString() => 'NotificationService(deviceToken: $_deviceToken, httpClient: $_httpClient)';
}

// Example user service - LazySingleton for user operations
@LazySingleton()
class UserService {
  final UserRepository _repository;
  final EmailService _emailService;

  UserService(this._repository, this._emailService);

  Future<User> getUser(String id) async {
    final user = await _repository.findById(id);
    // Send welcome email if new user
    if (user.name.contains('New')) {
      await _emailService.sendEmail(user.email, 'Welcome!', 'Welcome to our platform!');
    }
    return user;
  }

  Future<List<User>> getAllUsers() async {
    return await _repository.findAll();
  }

  @override
  String toString() => 'UserService(repository: $_repository, emailService: $_emailService)';
}

// Example mock repository implementation
class MockUserRepository implements UserRepository {
  final List<User> _users = [
    User(id: '1', name: 'John Doe', email: 'john@example.com'),
    User(id: '2', name: 'Jane Smith', email: 'jane@example.com'),
    User(id: '3', name: 'New User', email: 'new@example.com'),
  ];

  @override
  Future<User> findById(String id) async {
    await Future.delayed(Duration(milliseconds: 50)); // Simulate network delay
    final user = _users.firstWhere((user) => user.id == id);
    return user;
  }

  @override
  Future<List<User>> findAll() async {
    await Future.delayed(Duration(milliseconds: 100)); // Simulate network delay
    return List.from(_users);
  }

  @override
  String toString() => 'MockUserRepository(users: ${_users.length})';
}

// Example heavy computation service - LazySingleton for expensive operations
@LazySingleton()
class HeavyComputationService {
  late final List<int> _cache;

  HeavyComputationService() {
    // Simulate expensive initialization
    _cache = List.generate(1000000, (index) => index * 2);
  }

  int compute(int input) {
    return _cache[input % _cache.length];
  }

  @override
  String toString() => 'HeavyComputationService(cacheSize: ${_cache.length})';
}

// Example cache service - Singleton for app-wide caching
@Singleton()
class CacheService {
  final Map<String, dynamic> _cache = {};

  void set(String key, dynamic value) {
    _cache[key] = value;
  }

  dynamic get(String key) {
    return _cache[key];
  }

  void clear() {
    _cache.clear();
  }

  @override
  String toString() => 'CacheService(items: ${_cache.length})';
}

// Example analytics service - AsyncLazySingleton for analytics
@AsyncLazySingleton()
class AnalyticsService {
  final DatabaseService _database;
  final CacheService _cache;

  AnalyticsService(this._database, this._cache);

  Future<void> trackEvent(String event, Map<String, dynamic> properties) async {
    // Cache analytics data
    _cache.set('last_event', {'event': event, 'properties': properties, 'timestamp': DateTime.now()});
    
    // Store in database
    await _database.query('INSERT INTO analytics (event, properties) VALUES ("$event", "${properties.toString()}")');
  }

  @override
  String toString() => 'AnalyticsService(database: $_database, cache: $_cache)';
}

/// Main function demonstrating the usage of generated dependency injection methods
void main() async {
  print('🚀 DI Generator Build Example');
  print('==============================\n');

  try {
    // Get services using generated methods
    print('1. Getting AppConfig (Singleton - created immediately)');
    final appConfig = getAppConfig(
      apiUrl: 'https://api.example.com',
      apiKey: 'demo-key-123',
      debugMode: true,
    );
    print('   ✅ AppConfig: $appConfig\n');

    print('2. Getting HttpClient (LazySingleton - created on first use)');
    final httpClient = getHttpClient();
    print('   ✅ HttpClient: $httpClient\n');

    print('3. Getting DatabaseService (AsyncLazySingleton - async initialization)');
    final databaseService = await getDatabaseService(connectionString: 'postgresql://localhost:5432/mydb');
    await databaseService.initialize();
    print('   ✅ DatabaseService: $databaseService\n');

    print('4. Getting EmailService (Factory - new instance each time)');
    final emailService1 = getEmailService();
    final emailService2 = getEmailService();
    print('   ✅ EmailService 1: $emailService1');
    print('   ✅ EmailService 2: $emailService2');
    print('   📧 Factory pattern: ${emailService1 != emailService2 ? 'Different instances' : 'Same instance'}\n');

    print('5. Getting NotificationService (AsyncFactory - new async instance each time)');
    final notificationService1 = await getNotificationService(deviceToken: 'token1');
    final notificationService2 = await getNotificationService(deviceToken: 'token2');
    print('   ✅ NotificationService 1: $notificationService1');
    print('   ✅ NotificationService 2: $notificationService2');
    print('   📱 AsyncFactory pattern: ${notificationService1 != notificationService2 ? 'Different instances' : 'Same instance'}\n');

    print('6. Getting UserService (LazySingleton - created on first use)');
    final userService = getUserService();
    print('   ✅ UserService: $userService\n');

    print('7. Getting HeavyComputationService (LazySingleton - expensive operation deferred)');
    final heavyService = getHeavyComputationService();
    final result = heavyService.compute(42);
    print('   ✅ HeavyComputationService: $heavyService');
    print('   🧮 Computation result: $result\n');

    print('8. Getting CacheService (Singleton - created immediately)');
    final cacheService = getCacheService();
    cacheService.set('demo_key', 'demo_value');
    print('   ✅ CacheService: $cacheService');
    print('   💾 Cached value: ${cacheService.get('demo_key')}\n');

    print('9. Getting AnalyticsService (AsyncLazySingleton - async initialization)');
    final analyticsService = await getAnalyticsService();
    await analyticsService.trackEvent('user_login', {'user_id': '123', 'timestamp': DateTime.now()});
    print('   ✅ AnalyticsService: $analyticsService\n');

    print('10. Testing UserService functionality');
    final users = await userService.getAllUsers();
    print('   👥 Found ${users.length} users:');
    for (final user in users) {
      print('      - $user');
    }

    print('\n11. Testing individual user retrieval');
    final user = await userService.getUser('1');
    print('   👤 Retrieved user: $user');

    print('\n🎉 All services working correctly!');
    print('\n💡 Key Benefits Demonstrated:');
    print('   • LazySingleton: HeavyComputationService only created when needed');
    print('   • Factory: EmailService creates new instances each time');
    print('   • AsyncLazySingleton: DatabaseService async initialization deferred');
    print('   • Singleton: AppConfig and CacheService available immediately');
    print('   • Automatic dependency resolution through GetIt integration');

  } catch (e) {
    print('❌ Error: $e');
  }
}
