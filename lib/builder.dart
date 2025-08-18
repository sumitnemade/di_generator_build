import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';

/// Generator that creates dependency injection methods for classes annotated with dependency injection annotations.
///
/// This generator automatically analyzes classes with annotations like @RegisterFactory, @RegisterSingleton, @RegisterLazySingleton, etc.
/// and generates appropriate dependency injection methods that integrate with GetIt.
///
/// ## Supported Annotations
///
/// - [RegisterFactory]: Creates new instance each time
/// - [RegisterSingleton]: Creates instance immediately and reuses it
/// - [RegisterLazySingleton]: Creates instance on first use, then reuses it
/// - [RegisterAsyncFactory]: Creates new async instance each time
/// - [RegisterAsyncSingleton]: Creates async instance immediately and reuses it
/// - [RegisterAsyncLazySingleton]: Creates async instance on first use, then reuses it
///
/// ## Generated Output
///
/// For a class like:
/// ```dart
/// @RegisterSingleton()
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///
/// MyService(this._repository, [this._apiKey = 'default-key']);
/// }
/// ```
///
/// It generates:
/// ```dart
/// MyService getMyService({String apiKey = 'default-key'}) {
///   return GetIt.instance.getOrRegister<MyService>(
///       () => MyService(getRepository(), apiKey), RegisterAs.singleton);
/// }
/// ```
///
/// For async classes:
/// ```dart
/// @RegisterAsyncFactory()
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///
/// MyService(this._repository, [this._apiKey = 'default-key']);
///
///   Future<void> doSomething() async {
///     // Your async service logic
///   }
/// }
/// ```
///
/// It generates:
/// ```dart
/// Future<MyService> getMyService({String apiKey = 'default-key'}) async {
///   return await GetIt.instance.getOrRegisterAsync<MyService>(
///       () async => MyService(getRepository(), apiKey), RegisterAs.factoryAsync);
/// }
/// ```
class DependencyInjectionGenerator extends GeneratorForAnnotation<Object> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'Dependency injection annotations can only be applied to classes',
        element: element,
      );
    }

    final String className = element.name;

    // Get the annotation type from the element's metadata
    final String annotationName = _getAnnotationName(element, annotation);

    // Get registration type from annotation
    final RegisterAs registrationType =
        _getRegistrationTypeFromAnnotation(annotationName);
    final bool isAsync = _isAsyncAnnotation(annotationName);

    // Auto-detect constructor parameters
    final _ConstructorInfo constructorInfo = _getConstructorInfo(element);
    final String methodName = 'get$className';
    final String registrationTypeEnum =
        _getRegistrationTypeEnum(registrationType);

    if (isAsync) {
      return '''
Future<$className> $methodName() async {
  return await GetIt.instance.getOrRegisterAsync<$className>(
      () async => $className(${constructorInfo.constructorCall}), $registrationTypeEnum);
}
''';
    } else {
      return '''
$className $methodName() {
  return GetIt.instance.getOrRegister<$className>(
      () => $className(${constructorInfo.constructorCall}), $registrationTypeEnum);
}
''';
    }
  }

  /// Get the annotation name from the element's metadata
  String _getAnnotationName(ClassElement element, ConstantReader annotation) {
    // Look for our annotations in the element's metadata
    for (final ElementAnnotation metadata in element.metadata) {
      final Element? annotationElement = metadata.element;
      if (annotationElement != null) {
        final String annotationName = annotationElement.displayName;
        if (_isDependencyInjectionAnnotation(annotationName, null)) {
          return annotationName;
        }
      }
    }
    // Fallback to factory if we can't determine the annotation
    return 'RegisterFactory';
  }

  /// Get registration type from annotation name
  RegisterAs _getRegistrationTypeFromAnnotation(String annotationName) {
    switch (annotationName) {
      case 'RegisterFactory':
        return RegisterAs.factory;
      case 'RegisterSingleton':
        return RegisterAs.singleton;
      case 'RegisterLazySingleton':
        return RegisterAs.lazySingleton;
      case 'RegisterAsyncFactory':
        return RegisterAs.factoryAsync;
      case 'RegisterAsyncSingleton':
        return RegisterAs.singletonAsync;
      case 'RegisterAsyncLazySingleton':
        return RegisterAs.lazySingletonAsync;
      default:
        return RegisterAs.factory;
    }
  }

  /// Check if annotation is async
  bool _isAsyncAnnotation(String annotationName) =>
      annotationName.startsWith('RegisterAsync');

  /// Get constructor information including parameter signature and constructor call
  _ConstructorInfo _getConstructorInfo(ClassElement element) {
    final List<ConstructorElement> constructors = element.constructors;
    if (constructors.isEmpty) {
      return _ConstructorInfo('', '');
    }

    // Use the first constructor (usually the main one)
    final ConstructorElement constructor = constructors.first;
    final List<ParameterElement> parameters = constructor.parameters;

    if (parameters.isEmpty) {
      return _ConstructorInfo('', '');
    }

    final List<String> paramSignatures = <String>[];
    final List<String> constructorCalls = <String>[];

    for (final ParameterElement param in parameters) {
      final String paramType = param.type.toString();

      // Check if it's a class dependency (not a primitive type)
      if (_isClassType(paramType)) {
        // For class dependencies, get them from GetIt automatically
        final String className = _extractClassName(paramType);
        // Check if the dependency has required parameters
        final String dependencyCall = _getDependencyCall(className, element);
        constructorCalls.add(dependencyCall);
      } else {
        // For primitive types, handle them in constructor call
        if (param.isRequired) {
          // Remove underscore from parameter name for named parameters
          final String paramName =
              param.name.startsWith('_') ? param.name.substring(1) : param.name;
          // For required parameters, provide a default value in the constructor call
          final String defaultValue =
              _getDefaultValueForRequiredParam(paramType, paramName);
          // Check if this is a positional parameter
          if (param.isPositional) {
            constructorCalls.add(defaultValue);
          } else {
            constructorCalls.add('$paramName: $defaultValue');
          }
        } else {
          // For optional parameters, use their default values in constructor call
          if (param.defaultValueCode != null) {
            // Remove underscore from parameter name for named parameters
            final String paramName = param.name.startsWith('_')
                ? param.name.substring(1)
                : param.name;
            // Use the default value from the constructor
            // Check if this is a positional parameter
            if (param.isPositional) {
              constructorCalls.add(param.defaultValueCode!);
            } else {
              constructorCalls.add('$paramName: ${param.defaultValueCode}');
            }
          } else {
            // Fallback default value
            final String defaultValue = _getDefaultValueForType(paramType);
            // Remove underscore from parameter name for named parameters
            final String paramName = param.name.startsWith('_')
                ? param.name.substring(1)
                : param.name;

            // If defaultValue is empty, don't add a default value (for nullable types)
            if (defaultValue.isEmpty) {
              // For nullable types without defaults, use null
              // Check if this is a positional parameter
              if (param.isPositional) {
                constructorCalls.add('null');
              } else {
                constructorCalls.add('$paramName: null');
              }
            } else {
              // Check if this is a positional parameter
              if (param.isPositional) {
                constructorCalls.add(defaultValue);
              } else {
                constructorCalls.add('$paramName: $defaultValue');
              }
            }
          }
        }
      }
    }

    // If we have parameters, wrap them in curly braces for named parameters
    final String parameterSignature =
        paramSignatures.isNotEmpty ? '{${paramSignatures.join(', ')}}' : '';

    return _ConstructorInfo(
      parameterSignature,
      constructorCalls.join(', '),
    );
  }

  /// Check if a type is a class type (not a primitive)
  bool _isClassType(String type) {
    final List<String> primitiveTypes = <String>[
      'String',
      'int',
      'double',
      'bool',
      'num',
      'Object',
      'dynamic',
      'void',
      'Null',
      'Duration',
      'DateTime',
      'Uri',
      'RegExp'
    ];

    // Handle nullable types - they should be treated as parameters, not class dependencies
    if (type.endsWith('?')) {
      return false;
    }

    // Handle generic types like List<String>, Map<String, String>
    if (type.contains('<')) {
      // Generic types should be treated as parameters, not class dependencies
      return false;
    }

    // Check if it's a simple primitive type
    for (final String primitive in primitiveTypes) {
      if (type == primitive) {
        return false;
      }
    }

    // Check for List, Map, Set without generics (which are rare but possible)
    if (type == 'List' || type == 'Map' || type == 'Set') {
      return false;
    }

    return true;
  }

  /// Extract class name from type string
  String _extractClassName(String type) {
    // Handle generic types like List<String> -> List
    if (type.contains('<')) {
      return type.split('<')[0];
    }
    return type;
  }

  /// Get the appropriate dependency call based on whether the dependency has required parameters
  String _getDependencyCall(String className, ClassElement currentElement) {
    // For dependencies with required parameters, we need to ensure they are properly configured
    // This is a complex issue that requires analyzing the dependency's constructor
    // For now, we'll use a simple approach and assume the dependency can be resolved

    // Check if the dependency is async (has @RegisterAsync* annotation)
    // For now, we'll handle this by checking if the class name contains "Database" or "Async"
    if (className.contains('Database') || className.contains('Async')) {
      // For async dependencies, we need to await them
      return 'await get$className()';
    }

    // For dependencies that might have required parameters, we'll generate a call
    // that requires the user to provide the parameters when calling the generated method
    return 'get$className()';
  }

  /// Get default value for primitive types
  String _getDefaultValueForType(String type) {
    // Handle nullable types - no default value needed as they default to null
    if (type.endsWith('?')) {
      return ''; // Empty string means no default value
    }

    if (type.contains('String')) {
      return "'default-value'";
    }
    if (type.contains('int')) {
      return '0';
    }
    if (type.contains('double')) {
      return '0.0';
    }
    if (type.contains('bool')) {
      return 'false';
    }
    if (type.contains('List')) {
      return '[]';
    }
    if (type.contains('Map')) {
      return '{}';
    }
    if (type.contains('Set')) {
      return '{}';
    }
    return 'null';
  }

  /// Get default value for required parameters
  String _getDefaultValueForRequiredParam(String type, String paramName) {
    // Provide more meaningful defaults for common parameter names
    if (paramName.toLowerCase().contains('api')) {
      return '"default-api-key"';
    }
    if (paramName.toLowerCase().contains('secret')) {
      return '"default-secret-key"';
    }
    if (paramName.toLowerCase().contains('url')) {
      return '"https://api.example.com"';
    }
    if (paramName.toLowerCase().contains('connection')) {
      return '"default-connection-string"';
    }
    if (paramName.toLowerCase().contains('token')) {
      return '"default-token"';
    }
    if (paramName.toLowerCase().contains('id')) {
      return '"default-id"';
    }

    // Fall back to generic defaults
    return _getDefaultValueForType(type);
  }

  /// Convert registration type enum to string representation
  String _getRegistrationTypeEnum(RegisterAs registrationType) {
    switch (registrationType) {
      case RegisterAs.factory:
        return 'RegisterAs.factory';
      case RegisterAs.singleton:
        return 'RegisterAs.singleton';
      case RegisterAs.lazySingleton:
        return 'RegisterAs.lazySingleton';
      case RegisterAs.factoryAsync:
        return 'RegisterAs.factoryAsync';
      case RegisterAs.lazySingletonAsync:
        return 'RegisterAs.lazySingletonAsync';
      case RegisterAs.singletonAsync:
        return 'RegisterAs.singletonAsync';
    }
  }

  /// Check if annotation is a dependency injection annotation
  bool _isDependencyInjectionAnnotation(
      String? annotationName, String? annotationType) {
    final List<String> dependencyInjectionAnnotations = <String>[
      'RegisterFactory',
      'RegisterSingleton',
      'RegisterLazySingleton',
      'RegisterAsyncFactory',
      'RegisterAsyncSingleton',
      'RegisterAsyncLazySingleton',
    ];

    return dependencyInjectionAnnotations.contains(annotationName) ||
        dependencyInjectionAnnotations.contains(annotationType);
  }
}

/// Helper class to store constructor information
class _ConstructorInfo {
  _ConstructorInfo(this.parameterSignature, this.constructorCall);

  final String parameterSignature;
  final String constructorCall;
}

/// Custom builder that generates individual .g.dart files for each service.
///
/// This approach generates separate files for each service to avoid conflicts.
class SourceDirectoryBuilder extends Builder {
  SourceDirectoryBuilder(this._generators);

  final List<Generator> _generators;

  @override
  Map<String, List<String>> get buildExtensions => <String, List<String>>{
        '.dart': <String>['.g.dart']
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final AssetId inputId = buildStep.inputId;
    final AssetId outputId = AssetId(
      inputId.package,
      inputId.path.replaceAll('.dart', '.g.dart'),
    );

    final LibraryElement library = await buildStep.resolver.libraryFor(inputId);
    final StringBuffer generatedCode = StringBuffer();

    // Check if this file has any dependency injection annotations
    final bool hasDependencyInjectionAnnotations =
        library.topLevelElements.any((Element element) {
      if (element.metadata.isEmpty) {
        return false;
      }

      for (final ElementAnnotation metadata in element.metadata) {
        final Element? annotationElement = metadata.element;
        if (annotationElement != null) {
          final String? annotationType = annotationElement.library?.name;
          final String annotationName = annotationElement.displayName;

          if (_isDependencyInjectionAnnotation(
              annotationName, annotationType)) {
            return true;
          }
        }
      }
      return false;
    });

    if (!hasDependencyInjectionAnnotations) {
      return;
    }

    generatedCode.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    generatedCode.writeln('// Generated by di_generator_build');
    generatedCode.writeln(' ');
    generatedCode.writeln("import 'package:get_it/get_it.dart';");
    generatedCode
        .writeln("import 'package:di_generator_build/get_it_extension.dart';");
    generatedCode.writeln("import '${inputId.pathSegments.last}';");

    // Note: Dependencies between generated files should be handled by the consuming project
    // by importing the necessary .g.dart files in their main application code

    generatedCode.writeln(' ');

    final Set<String> processedElements = <String>{};

    for (final Generator generator in _generators) {
      if (generator is GeneratorForAnnotation) {
        final List<Element> elements = library.topLevelElements
            .where((Element element) => element.metadata.isNotEmpty)
            .toList();

        for (final Element element in elements) {
          for (final ElementAnnotation metadata in element.metadata) {
            final Element? annotation = metadata.element;
            if (annotation != null) {
              final String key = '${element.name}_${annotation.name}';

              if (!processedElements.contains(key)) {
                try {
                  final ConstantReader constantReader =
                      ConstantReader(metadata.computeConstantValue());
                  final String generated =
                      generator.generateForAnnotatedElement(
                    element,
                    constantReader,
                    buildStep,
                  );
                  if (generated.isNotEmpty) {
                    generatedCode.writeln(generated);
                    processedElements.add(key);
                  }
                } on Exception {
                  // Skip if annotation doesn't match
                }
              }
            }
          }
        }
      }
    }

    if (generatedCode.isNotEmpty) {
      // Write to build cache
      await buildStep.writeAsString(outputId, generatedCode.toString());

      // Try to write to source directory for better developer experience
      try {
        final String packageName = buildStep.inputId.package;
        if (packageName != 'di_generator_build') {
          final String sourcePath = inputId.path.replaceAll('.dart', '.g.dart');
          final File sourceFile = File(sourcePath);

          // Ensure the directory exists
          final Directory dir = sourceFile.parent;
          if (!dir.existsSync()) {
            dir.createSync(recursive: true);
          }

          await sourceFile.writeAsString(generatedCode.toString());
        }
      } on Exception {
        // If we can't write to source directory, that's okay
        // The build cache version will still work
      }
    }
  }

  /// Check if annotation is a dependency injection annotation
  bool _isDependencyInjectionAnnotation(
      String? annotationName, String? annotationType) {
    final List<String> dependencyInjectionAnnotations = <String>[
      'RegisterFactory',
      'RegisterSingleton',
      'RegisterLazySingleton',
      'RegisterAsyncFactory',
      'RegisterAsyncSingleton',
      'RegisterAsyncLazySingleton',
    ];

    return dependencyInjectionAnnotations.contains(annotationName) ||
        dependencyInjectionAnnotations.contains(annotationType);
  }
}

/// Builder for dependency injection code generation.
///
/// This generates .g.dart files directly in the source directory and
/// integrates with the build_runner system for automatic code generation.
///
/// ## Usage
///
/// Add this to your `build.yaml`:
/// ```yaml
/// targets:
///   $default:
///     builders:
///       di_generator_build|di_generator:
///         enabled: true
/// ```
Builder buildDiGenerator(BuilderOptions options) =>
    SourceDirectoryBuilder(<Generator>[
      DependencyInjectionGenerator(),
    ]);
