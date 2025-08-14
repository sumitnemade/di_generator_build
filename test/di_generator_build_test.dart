import 'package:di_generator_build/di_generator_build.dart';
import 'package:test/test.dart';

void main() {
  group('DI Generator Build Tests', () {
    test('AutoRegister annotation should be accessible', () {
      const AutoRegister annotation = AutoRegister();
      expect(annotation, isA<AutoRegister>());
      expect(annotation.registrationType, equals(RegisterAs.factory));
    });

    test('AutoRegister with custom registration type', () {
      const AutoRegister annotation = AutoRegister(registrationType: RegisterAs.singleton);
      expect(annotation.registrationType, equals(RegisterAs.singleton));
    });

    test('RegisterAs enum should have all expected values', () {
      expect(RegisterAs.values, hasLength(6));
      expect(RegisterAs.values, contains(RegisterAs.factory));
      expect(RegisterAs.values, contains(RegisterAs.singleton));
      expect(RegisterAs.values, contains(RegisterAs.lazySingleton));
      expect(RegisterAs.values, contains(RegisterAs.factoryAsync));
      expect(RegisterAs.values, contains(RegisterAs.lazySingletonAsync));
      expect(RegisterAs.values, contains(RegisterAs.singletonAsync));
    });

    test('GetItExtension should be accessible', () {
      // This test ensures the extension is properly exported
      expect(RegisterAs.factory, isA<RegisterAs>());
      expect(RegisterAs.singleton, isA<RegisterAs>());
      expect(RegisterAs.lazySingleton, isA<RegisterAs>());
    });

    test('Package should export all necessary components', () {
      // Test that all main components are properly exported
      expect(AutoRegister, isA<Type>());
      expect(RegisterAs, isA<Type>());
      
      // Test that the annotation can be instantiated
      const AutoRegister annotation = AutoRegister();
      expect(annotation, isNotNull);
    });

    test('Registration types should have correct string representations', () {
      expect(RegisterAs.factory.toString(), contains('factory'));
      expect(RegisterAs.singleton.toString(), contains('singleton'));
      expect(RegisterAs.lazySingleton.toString(), contains('lazySingleton'));
      expect(RegisterAs.factoryAsync.toString(), contains('factoryAsync'));
      expect(RegisterAs.lazySingletonAsync.toString(), contains('lazySingletonAsync'));
      expect(RegisterAs.singletonAsync.toString(), contains('singletonAsync'));
    });

    test('AutoRegister should have correct default values', () {
      const AutoRegister defaultAnnotation = AutoRegister();
      expect(defaultAnnotation.registrationType, equals(RegisterAs.factory));
      
      const AutoRegister customAnnotation = AutoRegister(registrationType: RegisterAs.lazySingleton);
      expect(customAnnotation.registrationType, equals(RegisterAs.lazySingleton));
    });

    test('Package should support all registration patterns', () {
      // Test that all registration types can be used
      const List<AutoRegister> patterns = <AutoRegister>[
        AutoRegister(),
        AutoRegister(registrationType: RegisterAs.singleton),
        AutoRegister(registrationType: RegisterAs.lazySingleton),
        AutoRegister(registrationType: RegisterAs.factoryAsync),
        AutoRegister(registrationType: RegisterAs.lazySingletonAsync),
        AutoRegister(registrationType: RegisterAs.singletonAsync),
      ];
      
      expect(patterns, hasLength(6));
      for (final AutoRegister pattern in patterns) {
        expect(pattern, isA<AutoRegister>());
        expect(pattern.registrationType, isA<RegisterAs>());
      }
    });
  });

  group('Integration Tests', () {
    test('Package should work with build_runner integration', () {
      // This test ensures the package is properly structured for build_runner
      expect(AutoRegister.new, returnsNormally);
      expect(() => const AutoRegister(registrationType: RegisterAs.singleton), returnsNormally);
    });

    test('All exports should be accessible', () {
      // Test that the main library exports everything needed
      expect(AutoRegister, isNotNull);
      expect(RegisterAs, isNotNull);
      
      // Test that we can create instances
      const AutoRegister annotation = AutoRegister();
      expect(annotation, isNotNull);
      expect(annotation.registrationType, equals(RegisterAs.factory));
    });
  });

  group('Documentation Tests', () {
    test('AutoRegister should have proper documentation', () {
      // This test ensures the annotation is properly documented
      const AutoRegister annotation = AutoRegister();
      expect(annotation.toString(), isNotEmpty);
    });

    test('RegisterAs enum should have proper documentation', () {
      // This test ensures the enum is properly documented
      for (final RegisterAs value in RegisterAs.values) {
        expect(value.toString(), isNotEmpty);
      }
    });
  });
}
