/// Example demonstrating the usage of di_generator_build package with dependency injection annotations.
///
/// This example shows how to use the new dependency injection annotations (@Factory, @Singleton, @LazySingleton, etc.)
/// for dependency injection in Dart/Flutter applications.
///
/// Run the code generator to see the generated code:
/// ```bash
/// dart run build_runner build
/// ```

import 'package:get_it/get_it.dart';
import 'package:di_generator_build/annotations.dart';

part 'example.g.dart';

@RegisterSingleton()
class AppConfig {
  final String apiUrl;
  final String apiKey;
  
  AppConfig({required this.apiUrl, required this.apiKey});
  
  void printConfig() {
    print('AppConfig: API URL=$apiUrl, API Key=$apiKey');
  }
}

@RegisterLazySingleton()
class HttpClient {
  final AppConfig _config;
  
  HttpClient(this._config);
  
  Future<String> get(String url) async {
    print('HttpClient: Making GET request to $url');
    return 'Response from $url';
  }
}

void main() async {
  print('=== DI Generator Build Example ===\n');

  // Create AppConfig immediately (singleton)
  print('1. Creating AppConfig (singleton)...');
  final appConfig = getAppConfig(
    apiUrl: 'https://api.example.com',
    apiKey: 'your-api-key-here',
  );
  appConfig.printConfig();
  print('');

  // Create HttpClient (lazy singleton - only when first requested)
  print('2. Requesting HttpClient (lazy singleton)...');
  final httpClient = getHttpClient();
  await httpClient.get('/api/health');
  print('');

  print('=== Example completed successfully! ===');
}
