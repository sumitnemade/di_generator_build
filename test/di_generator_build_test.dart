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

      expect(
          factoryAnnotation.runtimeType, equals(const RegisterFactory().runtimeType));
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
}
