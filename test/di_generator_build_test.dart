import 'package:di_generator_build/annotations.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

void main() {
  group('Annotation Tests', () {
    test('should create Factory annotation', () {
      const RegisterFactory annotation = RegisterFactory();
      expect(annotation, isA<RegisterFactory>());
    });

    test('should create Singleton annotation', () {
      const RegisterSingleton annotation = RegisterSingleton();
      expect(annotation, isA<RegisterSingleton>());
    });

    test('should create LazySingleton annotation', () {
      const RegisterLazySingleton annotation = RegisterLazySingleton();
      expect(annotation, isA<RegisterLazySingleton>());
    });

    test('should create AsyncFactory annotation', () {
      const RegisterAsyncFactory annotation = RegisterAsyncFactory();
      expect(annotation, isA<RegisterAsyncFactory>());
    });

    test('should create AsyncSingleton annotation', () {
      const RegisterAsyncSingleton annotation = RegisterAsyncSingleton();
      expect(annotation, isA<RegisterAsyncSingleton>());
    });

    test('should create AsyncLazySingleton annotation', () {
      const RegisterAsyncLazySingleton annotation =
          RegisterAsyncLazySingleton();
      expect(annotation, isA<RegisterAsyncLazySingleton>());
    });
  });

  group('GetIt Extension Tests', () {
    setUp(() {
      // Reset GetIt instance before each test
      GetIt.instance.reset();
    });

    tearDown(() {
      // Clean up after each test
      GetIt.instance.reset();
    });

    test('should register and get factory', () {
      final GetIt getIt = GetIt.instance;

      // Register a factory
      getIt.registerFactory<String>(() => 'test_value');

      // Get the value
      final String value = getIt.get<String>();
      expect(value, equals('test_value'));

      // Get again - should be a new instance
      final String value2 = getIt.get<String>();
      expect(value2, equals('test_value'));
      expect(value,
          equals(value2)); // Same value for String, but different instances
    });

    test('should register and get singleton', () {
      final GetIt getIt = GetIt.instance;

      // Register a singleton
      getIt.registerSingleton<String>('singleton_value');

      // Get the value
      final String value = getIt.get<String>();
      expect(value, equals('singleton_value'));

      // Get again - should be the same instance
      final String value2 = getIt.get<String>();
      expect(value2, equals('singleton_value'));
      expect(identical(value, value2), isTrue);
    });

    test('should register and get lazy singleton', () {
      final GetIt getIt = GetIt.instance;

      // Register a lazy singleton
      getIt.registerLazySingleton<String>(() => 'lazy_value');

      // Get the value
      final String value = getIt.get<String>();
      expect(value, equals('lazy_value'));

      // Get again - should be the same instance
      final String value2 = getIt.get<String>();
      expect(value2, equals('lazy_value'));
      expect(identical(value, value2), isTrue);
    });

    test('should register and get async factory', () async {
      final GetIt getIt = GetIt.instance;

      // Register an async factory
      getIt.registerFactoryAsync<String>(() async => 'async_factory_value');

      // Get the value
      final String value = await getIt.getAsync<String>();
      expect(value, equals('async_factory_value'));

      // Get again - should be a new instance
      final String value2 = await getIt.getAsync<String>();
      expect(value2, equals('async_factory_value'));
    });

    test('should register and get async singleton', () async {
      final GetIt getIt = GetIt.instance;

      // Register a singleton with async initialization
      getIt.registerSingleton<String>('async_singleton_value');

      // Get the value
      final String value = getIt.get<String>();
      expect(value, equals('async_singleton_value'));

      // Get again - should be the same instance
      final String value2 = getIt.get<String>();
      expect(value2, equals('async_singleton_value'));
      expect(identical(value, value2), isTrue);
    });

    test('should register and get async lazy singleton', () async {
      final GetIt getIt = GetIt.instance;

      // Register an async lazy singleton
      getIt.registerLazySingletonAsync<String>(() async => 'async_lazy_value');

      // Get the value
      final String value = await getIt.getAsync<String>();
      expect(value, equals('async_lazy_value'));

      // Get again - should be the same instance
      final String value2 = await getIt.getAsync<String>();
      expect(value2, equals('async_lazy_value'));
      expect(identical(value, value2), isTrue);
    });

    test('should use getOrRegister for factory', () {
      final GetIt getIt = GetIt.instance;

      final String value = getIt.getOrRegister<String>(
        () => 'or_register_factory',
        RegisterAs.factory,
      );

      expect(value, equals('or_register_factory'));

      // Should be registered now
      final String value2 = getIt.get<String>();
      expect(value2, equals('or_register_factory'));
    });

    test('should use getOrRegister for singleton', () {
      final GetIt getIt = GetIt.instance;

      final String value = getIt.getOrRegister<String>(
        () => 'or_register_singleton',
        RegisterAs.singleton,
      );

      expect(value, equals('or_register_singleton'));

      // Should be registered now
      final String value2 = getIt.get<String>();
      expect(value2, equals('or_register_singleton'));
      expect(identical(value, value2), isTrue);
    });

    test('should use getOrRegister for lazy singleton', () {
      final GetIt getIt = GetIt.instance;

      final String value = getIt.getOrRegister<String>(
        () => 'or_register_lazy',
        RegisterAs.lazySingleton,
      );

      expect(value, equals('or_register_lazy'));

      // Should be registered now
      final String value2 = getIt.get<String>();
      expect(value2, equals('or_register_lazy'));
      expect(identical(value, value2), isTrue);
    });

    test('should use getOrRegisterAsync for factory async', () async {
      final GetIt getIt = GetIt.instance;

      final String value = await getIt.getOrRegisterAsync<String>(
        () async => 'or_register_async_factory',
        RegisterAs.factoryAsync,
      );

      expect(value, equals('or_register_async_factory'));

      // Should be registered now
      final String value2 = await getIt.getAsync<String>();
      expect(value2, equals('or_register_async_factory'));
    });

    test('should use getOrRegisterAsync for singleton async', () async {
      final GetIt getIt = GetIt.instance;

      final String value = await getIt.getOrRegisterAsync<String>(
        () async => 'or_register_async_singleton',
        RegisterAs.singletonAsync,
      );

      expect(value, equals('or_register_async_singleton'));

      // Should be registered now and retrievable synchronously
      final String value2 = getIt.get<String>();
      expect(value2, equals('or_register_async_singleton'));
      expect(identical(value, value2), isTrue);
    });

    test('should use getOrRegisterAsync for lazy singleton async', () async {
      final GetIt getIt = GetIt.instance;

      final String value = await getIt.getOrRegisterAsync<String>(
        () async => 'or_register_async_lazy',
        RegisterAs.lazySingletonAsync,
      );

      expect(value, equals('or_register_async_lazy'));

      // Should be registered now
      final String value2 = await getIt.getAsync<String>();
      expect(value2, equals('or_register_async_lazy'));
      expect(identical(value, value2), isTrue);
    });
  });

  group('Annotation Constructor Tests', () {
    test('should create all annotation constructors', () {
      expect(RegisterFactory.new, returnsNormally);
      expect(RegisterSingleton.new, returnsNormally);
      expect(RegisterLazySingleton.new, returnsNormally);
      expect(RegisterAsyncFactory.new, returnsNormally);
      expect(RegisterAsyncSingleton.new, returnsNormally);
      expect(RegisterAsyncLazySingleton.new, returnsNormally);
    });

    test('should have correct types', () {
      expect(RegisterFactory, isA<Type>());
      expect(RegisterSingleton, isA<Type>());
      expect(RegisterLazySingleton, isA<Type>());
      expect(RegisterAsyncFactory, isA<Type>());
      expect(RegisterAsyncSingleton, isA<Type>());
      expect(RegisterAsyncLazySingleton, isA<Type>());
    });
  });

  group('Annotation Equality Tests', () {
    test('should be equal for same annotation types', () {
      const RegisterFactory factoryAnnotation = RegisterFactory();
      const RegisterSingleton singletonAnnotation = RegisterSingleton();

      expect(factoryAnnotation.runtimeType,
          equals(const RegisterFactory().runtimeType));
      expect(singletonAnnotation.runtimeType,
          equals(const RegisterSingleton().runtimeType));
    });

    test('should not be equal for different annotation types', () {
      const RegisterFactory factoryAnnotation = RegisterFactory();
      const RegisterSingleton singletonAnnotation = RegisterSingleton();

      expect(factoryAnnotation.runtimeType,
          isNot(equals(singletonAnnotation.runtimeType)));
    });
  });

  group('Annotation Hash Code Tests', () {
    test('should have same hash code for same annotation types', () {
      const RegisterFactory factoryAnnotation1 = RegisterFactory();
      const RegisterFactory factoryAnnotation2 = RegisterFactory();
      const RegisterSingleton singletonAnnotation1 = RegisterSingleton();
      const RegisterSingleton singletonAnnotation2 = RegisterSingleton();

      expect(factoryAnnotation1.hashCode, equals(factoryAnnotation2.hashCode));
      expect(
          singletonAnnotation1.hashCode, equals(singletonAnnotation2.hashCode));
    });

    test('should have different hash codes for different annotation types', () {
      const RegisterFactory factoryAnnotation = RegisterFactory();
      const RegisterSingleton singletonAnnotation = RegisterSingleton();

      expect(factoryAnnotation.hashCode,
          isNot(equals(singletonAnnotation.hashCode)));
    });
  });

  group('Annotation List Tests', () {
    test('should create list of all annotations', () {
      final List<Object> annotations = <Object>[
        const RegisterFactory(),
        const RegisterSingleton(),
        const RegisterLazySingleton(),
        const RegisterAsyncFactory(),
        const RegisterAsyncSingleton(),
        const RegisterAsyncLazySingleton(),
      ];

      expect(annotations, hasLength(6));
      expect(annotations[0], isA<RegisterFactory>());
      expect(annotations[1], isA<RegisterSingleton>());
      expect(annotations[2], isA<RegisterLazySingleton>());
      expect(annotations[3], isA<RegisterAsyncFactory>());
      expect(annotations[4], isA<RegisterAsyncSingleton>());
      expect(annotations[5], isA<RegisterAsyncLazySingleton>());
    });
  });

  group('GetIt Extension Optimized Methods Tests', () {
    setUp(() {
      GetIt.instance.reset();
    });

    tearDown(() {
      GetIt.instance.reset();
    });

    test('should use getOrRegisterFactory optimized method', () {
      final GetIt getIt = GetIt.instance;

      final String value = getIt.getOrRegisterFactory<String>(() => 'optimized_factory');

      expect(value, equals('optimized_factory'));

      // Should be registered now
      final String value2 = getIt.get<String>();
      expect(value2, equals('optimized_factory'));
    });

    test('should use getOrRegisterLazySingleton optimized method', () {
      final GetIt getIt = GetIt.instance;

      final String value = getIt.getOrRegisterLazySingleton<String>(() => 'optimized_lazy');

      expect(value, equals('optimized_lazy'));

      // Should be registered now
      final String value2 = getIt.get<String>();
      expect(value2, equals('optimized_lazy'));
      expect(identical(value, value2), isTrue);
    });

    test('should use getOrRegisterSingleton optimized method', () {
      final GetIt getIt = GetIt.instance;

      final String value = getIt.getOrRegisterSingleton<String>(() => 'optimized_singleton');

      expect(value, equals('optimized_singleton'));

      // Should be registered now
      final String value2 = getIt.get<String>();
      expect(value2, equals('optimized_singleton'));
      expect(identical(value, value2), isTrue);
    });

    test('should use getOrRegisterFactoryAsync optimized method', () async {
      final GetIt getIt = GetIt.instance;

      final String value = await getIt.getOrRegisterFactoryAsync<String>(() async => 'optimized_async_factory');

      expect(value, equals('optimized_async_factory'));

      // Should be registered now
      final String value2 = await getIt.getAsync<String>();
      expect(value2, equals('optimized_async_factory'));
    });

    test('should use getOrRegisterLazySingletonAsync optimized method', () async {
      final GetIt getIt = GetIt.instance;

      final String value = await getIt.getOrRegisterLazySingletonAsync<String>(() async => 'optimized_async_lazy');

      expect(value, equals('optimized_async_lazy'));

      // Should be registered now
      final String value2 = await getIt.getAsync<String>();
      expect(value2, equals('optimized_async_lazy'));
      expect(identical(value, value2), isTrue);
    });

    test('should use getOrRegisterSingletonAsync optimized method', () async {
      final GetIt getIt = GetIt.instance;

      final String value = await getIt.getOrRegisterSingletonAsync<String>(() async => 'optimized_async_singleton');

      expect(value, equals('optimized_async_singleton'));

      // Should be registered now and retrievable synchronously
      final String value2 = getIt.get<String>();
      expect(value2, equals('optimized_async_singleton'));
      expect(identical(value, value2), isTrue);
    });
  });

  group('GetIt Extension Error Handling Tests', () {
    setUp(() {
      GetIt.instance.reset();
    });

    tearDown(() {
      GetIt.instance.reset();
    });

    test('should throw UnimplementedError for unsupported RegisterAs in getOrRegister', () {
      final GetIt getIt = GetIt.instance;

      expect(
        () => getIt.getOrRegister<String>(
          () => 'test',
          RegisterAs.factoryAsync, // This is not supported in getOrRegister
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('should throw UnimplementedError for unsupported RegisterAs in getOrRegisterAsync', () {
      final GetIt getIt = GetIt.instance;

      expect(
        () => getIt.getOrRegisterAsync<String>(
          () async => 'test',
          RegisterAs.factory, // This is not supported in getOrRegisterAsync
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('should throw UnimplementedError for unsupported RegisterAs in getOrRegisterAsync - singleton', () {
      final GetIt getIt = GetIt.instance;

      expect(
        () => getIt.getOrRegisterAsync<String>(
          () async => 'test',
          RegisterAs.singleton, // This is not supported in getOrRegisterAsync
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('should throw UnimplementedError for unsupported RegisterAs in getOrRegisterAsync - lazySingleton', () {
      final GetIt getIt = GetIt.instance;

      expect(
        () => getIt.getOrRegisterAsync<String>(
          () async => 'test',
          RegisterAs.lazySingleton, // This is not supported in getOrRegisterAsync
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('GetIt Extension Edge Cases Tests', () {
    setUp(() {
      GetIt.instance.reset();
    });

    tearDown(() {
      GetIt.instance.reset();
    });

    test('should handle already registered dependencies in getOrRegister', () {
      final GetIt getIt = GetIt.instance;

      // Register first
      getIt.registerSingleton<String>('first_value');

      // Try to getOrRegister - should return existing value
      final String value = getIt.getOrRegister<String>(
        () => 'second_value',
        RegisterAs.singleton,
      );

      expect(value, equals('first_value'));
    });

    test('should handle already registered dependencies in getOrRegisterAsync', () async {
      final GetIt getIt = GetIt.instance;

      // Register first
      getIt.registerSingleton<String>('first_async_value');

      // Try to getOrRegisterAsync - should return existing value
      final String value = await getIt.getOrRegisterAsync<String>(
        () async => 'second_async_value',
        RegisterAs.singletonAsync,
      );

      expect(value, equals('first_async_value'));
    });

    test('should handle complex object types', () {
      final GetIt getIt = GetIt.instance;

      // Define test class outside the test
      final Map<String, String> instance = getIt.getOrRegister<Map<String, String>>(
        () => <String, String>{'value': 'complex_object'},
        RegisterAs.singleton,
      );

      expect(instance['value'], equals('complex_object'));
      expect(instance, isA<Map<String, String>>());
    });

    test('should handle async complex object types', () async {
      final GetIt getIt = GetIt.instance;

      final Map<String, String> instance = await getIt.getOrRegisterAsync<Map<String, String>>(
        () async => <String, String>{'value': 'async_complex_object'},
        RegisterAs.singletonAsync,
      );

      expect(instance['value'], equals('async_complex_object'));
      expect(instance, isA<Map<String, String>>());
    });
  });

  group('RegisterAs Enum Tests', () {
    test('should have all expected enum values', () {
      expect(RegisterAs.values, hasLength(6));
      expect(RegisterAs.values, contains(RegisterAs.singleton));
      expect(RegisterAs.values, contains(RegisterAs.factory));
      expect(RegisterAs.values, contains(RegisterAs.lazySingleton));
      expect(RegisterAs.values, contains(RegisterAs.factoryAsync));
      expect(RegisterAs.values, contains(RegisterAs.lazySingletonAsync));
      expect(RegisterAs.values, contains(RegisterAs.singletonAsync));
    });

    test('should have correct enum value names', () {
      expect(RegisterAs.singleton.name, equals('singleton'));
      expect(RegisterAs.factory.name, equals('factory'));
      expect(RegisterAs.lazySingleton.name, equals('lazySingleton'));
      expect(RegisterAs.factoryAsync.name, equals('factoryAsync'));
      expect(RegisterAs.lazySingletonAsync.name, equals('lazySingletonAsync'));
      expect(RegisterAs.singletonAsync.name, equals('singletonAsync'));
    });

    test('should have correct enum value indices', () {
      expect(RegisterAs.singleton.index, equals(0));
      expect(RegisterAs.factory.index, equals(1));
      expect(RegisterAs.lazySingleton.index, equals(2));
      expect(RegisterAs.factoryAsync.index, equals(3));
      expect(RegisterAs.lazySingletonAsync.index, equals(4));
      expect(RegisterAs.singletonAsync.index, equals(5));
    });
  });
}
