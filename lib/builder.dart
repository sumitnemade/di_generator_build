import 'dart:io';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotations.dart';

/// Generator that creates dependency injection methods for classes annotated with [AutoRegister].
///
/// This generator automatically analyzes classes with the [AutoRegister] annotation and
/// generates appropriate dependency injection methods that integrate with GetIt.
///
/// ## Generated Output
///
/// For a class like:
/// ```dart
/// @AutoRegister(registrationType: RegisterAs.singleton)
/// class MyService {
///   final Repository _repository;
///   final String _apiKey;
///
///   MyService(this._repository, [this._apiKey = 'default-key']);
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
class AutoRegisterGenerator extends GeneratorForAnnotation<AutoRegister> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'AutoRegister annotation can only be applied to classes',
        element: element,
      );
    }

    final String className = element.name;

    // Get registration type from annotation
    RegisterAs registrationType;
    try {
      final DartObject registrationTypeValue =
          annotation.read('registrationType').objectValue;
      registrationType = _getRegistrationTypeFromObject(registrationTypeValue);
    } on Exception {
      registrationType = RegisterAs.factory;
    }

    // Auto-detect constructor parameters
    final _ConstructorInfo constructorInfo = _getConstructorInfo(element);
    final String methodName = 'get$className';
    final String registrationTypeEnum =
        _getRegistrationTypeEnum(registrationType);

    return '''
$className $methodName(${constructorInfo.parameterSignature}) {
  return GetIt.instance.getOrRegister<$className>(
      () => $className(${constructorInfo.constructorCall}), $registrationTypeEnum);
}
''';
  }

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
        constructorCalls.add('get$className()');
      } else {
        // For primitive types, add to method signature
        if (param.isRequired) {
          // Remove underscore from parameter name for named parameters
          final String paramName =
              param.name.startsWith('_') ? param.name.substring(1) : param.name;
          paramSignatures.add('${param.type} $paramName');
          constructorCalls.add(paramName);
        } else {
          // For optional parameters, add to method signature with default value
          if (param.defaultValueCode != null) {
            // Remove underscore from parameter name for named parameters
            final String paramName = param.name.startsWith('_')
                ? param.name.substring(1)
                : param.name;
            paramSignatures
                .add('${param.type} $paramName = ${param.defaultValueCode}');
            constructorCalls.add(paramName);
          } else {
            // Fallback default value
            final String defaultValue = _getDefaultValueForType(paramType);
            // Remove underscore from parameter name for named parameters
            final String paramName = param.name.startsWith('_')
                ? param.name.substring(1)
                : param.name;
            paramSignatures.add('${param.type} $paramName = $defaultValue');
            constructorCalls.add(paramName);
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
      'List',
      'Map',
      'Set',
      'num',
      'Object',
      'dynamic',
      'void',
      'Null'
    ];

    // Check if it contains any primitive type
    for (final String primitive in primitiveTypes) {
      if (type.contains(primitive) && !type.contains('<')) {
        return false;
      }
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

  /// Get default value for primitive types
  String _getDefaultValueForType(String type) {
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

  /// Parse registration type from annotation object
  RegisterAs _getRegistrationTypeFromObject(Object? value) {
    if (value == null) {
      return RegisterAs.factory;
    }

    final String valueString = value.toString();
    if (valueString.contains('RegisterAs.factory')) {
      return RegisterAs.factory;
    }
    if (valueString.contains('RegisterAs.singleton')) {
      return RegisterAs.singleton;
    }
    if (valueString.contains('RegisterAs.lazySingleton')) {
      return RegisterAs.lazySingleton;
    }
    // if (valueString.contains('RegisterAs.factoryAsync')) return RegisterAs.factoryAsync;
    // if (valueString.contains('RegisterAs.lazySingletonAsync')) return RegisterAs.lazySingletonAsync;
    // if (valueString.contains('RegisterAs.singletonAsync')) return RegisterAs.singletonAsync;

    return RegisterAs.factory;
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
      default:
        return 'RegisterAs.factory';
      // case RegisterAs.factoryAsync:
      //   return 'RegisterAs.factoryAsync';
      // case RegisterAs.lazySingletonAsync:
      //   return 'RegisterAs.lazySingletonAsync';
      // case RegisterAs.singletonAsync:
      //   return 'RegisterAs.singletonAsync';
    }
  }
}

/// Helper class to store constructor information
class _ConstructorInfo {
  _ConstructorInfo(this.parameterSignature, this.constructorCall);

  final String parameterSignature;
  final String constructorCall;
}

/// Custom builder that generates .g.dart files directly in the source directory.
///
/// This ensures the generated code can be used directly in the codebase and
/// provides a better developer experience by placing generated files alongside
/// source files.
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

    // Check if this file has any @AutoRegister annotations
    final bool hasAutoRegisterAnnotations =
        library.topLevelElements.any((Element element) {
      if (element.metadata.isEmpty) {
        return false;
      }

      for (final ElementAnnotation metadata in element.metadata) {
        final Element? annotationElement = metadata.element;
        if (annotationElement != null) {
          // Check if this is an AutoRegister annotation by checking the type
          final String? annotationType =
              annotationElement.enclosingElement3?.name;
          final String? annotationName = annotationElement.name;

          // Check if it's an AutoRegister annotation from our package
          if (annotationName == 'AutoRegister' ||
              annotationType == 'AutoRegister') {
            return true;
          }
        }
      }
      return false;
    });

    if (!hasAutoRegisterAnnotations) {
      // Skip this file if it doesn't have @AutoRegister annotations
      return;
    }

    generatedCode.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    generatedCode.writeln('// Generated by di_generator_build');
    generatedCode.writeln(' ');
    generatedCode.writeln("part of '${inputId.pathSegments.last}';");
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
                  final generated = generator.generateForAnnotatedElement(
                    element,
                    constantReader,
                    buildStep,
                  );
                  if (generated.isNotEmpty) {
                    generatedCode.writeln(generated);
                    processedElements.add(key);
                  }
                } on Exception{
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
        // Get the absolute path to the source file
        final String sourceDir = buildStep.inputId.path;
        final String packageName = buildStep.inputId.package;

        // Try to write to source directory for any package that's not a dependency
        if (packageName != 'di_generator_build') {
          final String sourcePath = sourceDir.replaceAll('.dart', '.g.dart');
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
    } else {
      // If no content was generated, don't create empty .g.dart files
    }
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
      AutoRegisterGenerator(),
    ]);
