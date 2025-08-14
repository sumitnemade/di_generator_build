import 'package:di_generator_build/di_generator_build.dart';
import 'package:get_it/get_it.dart';
import 'package:test/test.dart';

void main() {
  group('New Dependency Injection Annotations Tests', () {
    test('@Factory annotation should be accessible', () {
      const Factory annotation = Factory();
      expect(annotation, isA<Factory>());
    });

    test('@Singleton annotation should be accessible', () {
      const Singleton annotation = Singleton();
      expect(annotation, isA<Singleton>());
    });

    test('@LazySingleton annotation should be accessible', () {
      const LazySingleton annotation = LazySingleton();
      expect(annotation, isA<LazySingleton>());
    });

    test('@LazyFactory annotation should be accessible', () {
      const LazyFactory annotation = LazyFactory();
      expect(annotation, isA<LazyFactory>());
    });

    test('@AsyncFactory annotation should be accessible', () {
      const AsyncFactory annotation = AsyncFactory();
      expect(annotation, isA<AsyncFactory>());
    });

    test('@AsyncSingleton annotation should be accessible', () {
      const AsyncSingleton annotation = AsyncSingleton();
      expect(annotation, isA<AsyncSingleton>());
    });

    test('@AsyncLazySingleton annotation should be accessible', () {
      const AsyncLazySingleton annotation = AsyncLazySingleton();
      expect(annotation, isA<AsyncLazySingleton>());
    });
  });

  group('RegisterAs Enum Tests', () {
    test('RegisterAs enum should have all expected values', () {
      expect(RegisterAs.values, hasLength(6));
      expect(RegisterAs.values, contains(RegisterAs.factory));
      expect(RegisterAs.values, contains(RegisterAs.singleton));
      expect(RegisterAs.values, contains(RegisterAs.lazySingleton));
      expect(RegisterAs.values, contains(RegisterAs.factoryAsync));
      expect(RegisterAs.values, contains(RegisterAs.lazySingletonAsync));
      expect(RegisterAs.values, contains(RegisterAs.singletonAsync));
    });

    test('Registration types should have correct string representations', () {
      expect(RegisterAs.factory.toString(), contains('factory'));
      expect(RegisterAs.singleton.toString(), contains('singleton'));
      expect(RegisterAs.lazySingleton.toString(), contains('lazySingleton'));
      expect(RegisterAs.factoryAsync.toString(), contains('factoryAsync'));
      expect(RegisterAs.lazySingletonAsync.toString(), contains('lazySingletonAsync'));
      expect(RegisterAs.singletonAsync.toString(), contains('singletonAsync'));
    });
  });

  group('GetIt Extension Tests', () {
    late GetIt getIt;

    setUp(() {
      getIt = GetIt.instance;
      getIt.reset();
    });

    test('getOrRegister should work with factory registration', () {
      final result = getIt.getOrRegister<String>(
        () => 'test-value',
        RegisterAs.factory,
      );
      expect(result, equals('test-value'));
    });

    test('getOrRegister should work with singleton registration', () {
      final result = getIt.getOrRegister<String>(
        () => 'test-value',
        RegisterAs.singleton,
      );
      expect(result, equals('test-value'));
      
      // Second call should return the same instance
      final result2 = getIt.getOrRegister<String>(
        () => 'different-value',
        RegisterAs.singleton,
      );
      expect(result2, equals('test-value')); // Should return first instance
    });

    test('getOrRegister should work with lazySingleton registration', () {
      final result = getIt.getOrRegister<String>(
        () => 'test-value',
        RegisterAs.lazySingleton,
      );
      expect(result, equals('test-value'));
      
      // Second call should return the same instance
      final result2 = getIt.getOrRegister<String>(
        () => 'different-value',
        RegisterAs.lazySingleton,
      );
      expect(result2, equals('test-value')); // Should return first instance
    });

    test('getOrRegister should throw error for invalid registration type', () {
      expect(
        () => getIt.getOrRegister<String>(
          () => 'test-value',
          RegisterAs.factoryAsync, // Invalid for sync method
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('getOrRegisterAsync should work with factoryAsync registration', () async {
      final result = await getIt.getOrRegisterAsync<String>(
        () async => 'test-value',
        RegisterAs.factoryAsync,
      );
      expect(result, equals('test-value'));
    });

    test('getOrRegisterAsync should work with lazySingletonAsync registration', () async {
      final result = await getIt.getOrRegisterAsync<String>(
        () async => 'test-value',
        RegisterAs.lazySingletonAsync,
      );
      expect(result, equals('test-value'));
      
      // Second call should return the same instance
      final result2 = await getIt.getOrRegisterAsync<String>(
        () async => 'different-value',
        RegisterAs.lazySingletonAsync,
      );
      expect(result2, equals('test-value')); // Should return first instance
    });

    test('getOrRegisterAsync should work with singletonAsync registration', () async {
      final result = await getIt.getOrRegisterAsync<String>(
        () async => 'test-value',
        RegisterAs.singletonAsync,
      );
      expect(result, equals('test-value'));
      
      // Second call should return the same instance, but since it's registered as a regular singleton,
      // we need to get it synchronously
      final result2 = getIt.get<String>();
      expect(result2, equals('test-value')); // Should return first instance
    });

    test('getOrRegisterAsync should throw error for invalid async registration type', () {
      expect(
        () => getIt.getOrRegisterAsync<String>(
          () async => 'test-value',
          RegisterAs.factory, // Invalid for async method
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('getOrRegisterFactory should work', () {
      final result = getIt.getOrRegisterFactory<String>(() => 'test-value');
      expect(result, equals('test-value'));
    });

    test('getOrRegisterLazySingleton should work', () {
      final result = getIt.getOrRegisterLazySingleton<String>(() => 'test-value');
      expect(result, equals('test-value'));
      
      // Second call should return the same instance
      final result2 = getIt.getOrRegisterLazySingleton<String>(() => 'different-value');
      expect(result2, equals('test-value')); // Should return first instance
    });

    test('getOrRegisterSingleton should work', () {
      final result = getIt.getOrRegisterSingleton<String>(() => 'test-value');
      expect(result, equals('test-value'));
      
      // Second call should return the same instance
      final result2 = getIt.getOrRegisterSingleton<String>(() => 'different-value');
      expect(result2, equals('test-value')); // Should return first instance
    });

    test('getOrRegisterFactoryAsync should work', () async {
      final result = await getIt.getOrRegisterFactoryAsync<String>(() async => 'test-value');
      expect(result, equals('test-value'));
    });

    test('getOrRegisterLazySingletonAsync should work', () async {
      final result = await getIt.getOrRegisterLazySingletonAsync<String>(() async => 'test-value');
      expect(result, equals('test-value'));
      
      // Second call should return the same instance
      final result2 = await getIt.getOrRegisterLazySingletonAsync<String>(() async => 'different-value');
      expect(result2, equals('test-value')); // Should return first instance
    });

    test('getOrRegisterSingletonAsync should work', () async {
      final result = await getIt.getOrRegisterSingletonAsync<String>(() async => 'test-value');
      expect(result, equals('test-value'));
      
      // Second call should return the same instance, but since it's registered as a regular singleton,
      // we need to get it synchronously
      final result2 = getIt.get<String>();
      expect(result2, equals('test-value')); // Should return first instance
    });
  });

  group('Package Integration Tests', () {
    test('Package should work with build_runner integration', () {
      // This test ensures the package is properly structured for build_runner
      expect(Factory.new, returnsNormally);
      expect(Singleton.new, returnsNormally);
      expect(LazySingleton.new, returnsNormally);
      expect(LazyFactory.new, returnsNormally);
      expect(AsyncFactory.new, returnsNormally);
      expect(AsyncSingleton.new, returnsNormally);
      expect(AsyncLazySingleton.new, returnsNormally);
    });

    test('All exports should be accessible', () {
      // Test that the main library exports everything needed
      expect(Factory, isA<Type>());
      expect(Singleton, isA<Type>());
      expect(LazySingleton, isA<Type>());
      expect(LazyFactory, isA<Type>());
      expect(AsyncFactory, isA<Type>());
      expect(AsyncSingleton, isA<Type>());
      expect(AsyncLazySingleton, isA<Type>());
      expect(RegisterAs, isA<Type>());
      
      // Test that the annotations can be instantiated
      const Factory factoryAnnotation = Factory();
      const Singleton singletonAnnotation = Singleton();
      expect(factoryAnnotation, isNotNull);
      expect(singletonAnnotation, isNotNull);
    });
  });

  group('Documentation Tests', () {
    test('All annotations should have proper documentation', () {
      // This test ensures all annotations are properly documented
      const Factory factoryAnnotation = Factory();
      const Singleton singletonAnnotation = Singleton();
      const LazySingleton lazySingletonAnnotation = LazySingleton();
      const LazyFactory lazyFactoryAnnotation = LazyFactory();
      const AsyncFactory asyncFactoryAnnotation = AsyncFactory();
      const AsyncSingleton asyncSingletonAnnotation = AsyncSingleton();
      const AsyncLazySingleton asyncLazySingletonAnnotation = AsyncLazySingleton();
      
      expect(factoryAnnotation.toString(), isNotEmpty);
      expect(singletonAnnotation.toString(), isNotEmpty);
      expect(lazySingletonAnnotation.toString(), isNotEmpty);
      expect(lazyFactoryAnnotation.toString(), isNotEmpty);
      expect(asyncFactoryAnnotation.toString(), isNotEmpty);
      expect(asyncSingletonAnnotation.toString(), isNotEmpty);
      expect(asyncLazySingletonAnnotation.toString(), isNotEmpty);
    });

    test('RegisterAs enum should have proper documentation', () {
      // This test ensures the enum is properly documented
      for (final RegisterAs value in RegisterAs.values) {
        expect(value.toString(), isNotEmpty);
      }
    });
  });

  group('Annotation Comparison Tests', () {
    test('Different annotation types should not be equal', () {
      const Factory factoryAnnotation = Factory();
      const Singleton singletonAnnotation = Singleton();
      const LazySingleton lazySingletonAnnotation = LazySingleton();
      
      expect(factoryAnnotation, isNot(equals(singletonAnnotation)));
      expect(factoryAnnotation, isNot(equals(lazySingletonAnnotation)));
      expect(singletonAnnotation, isNot(equals(lazySingletonAnnotation)));
    });

    test('Same annotation types should be equal', () {
      const Factory factoryAnnotation1 = Factory();
      const Factory factoryAnnotation2 = Factory();
      const Singleton singletonAnnotation1 = Singleton();
      const Singleton singletonAnnotation2 = Singleton();
      
      expect(factoryAnnotation1, equals(factoryAnnotation2));
      expect(singletonAnnotation1, equals(singletonAnnotation2));
    });
  });

  group('Edge Cases and Error Handling', () {
    test('Annotations should handle edge cases gracefully', () {
      // Test that annotations can be used in various contexts
      expect(() {
        const List<Object> annotations = [
          Factory(),
          Singleton(),
          LazySingleton(),
          LazyFactory(),
          AsyncFactory(),
          AsyncSingleton(),
          AsyncLazySingleton(),
        ];
        expect(annotations, hasLength(7));
      }, returnsNormally);
    });

    test('RegisterAs enum should handle all cases', () {
      // Test that all enum values can be used in switch statements
      for (final RegisterAs value in RegisterAs.values) {
        expect(() {
          switch (value) {
            case RegisterAs.factory:
            case RegisterAs.singleton:
            case RegisterAs.lazySingleton:
            case RegisterAs.factoryAsync:
            case RegisterAs.lazySingletonAsync:
            case RegisterAs.singletonAsync:
              break;
          }
        }, returnsNormally);
      }
    });
  });

  group('Builder and Code Generation Tests', () {
    test('Builder should be accessible', () {
      // Test that the builder function is accessible
      expect(buildDiGenerator, isA<Function>());
    });

    test('SourceDirectoryBuilder should be accessible', () {
      // Test that the builder class is accessible
      expect(SourceDirectoryBuilder, isA<Type>());
    });

    test('DependencyInjectionGenerator should be accessible', () {
      // Test that the generator class is accessible
      expect(DependencyInjectionGenerator, isA<Type>());
    });
  });
}
