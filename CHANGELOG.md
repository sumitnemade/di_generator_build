# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-19

### Added
- Initial release of DI Generator Build package
- `@AutoRegister` annotation for automatic dependency injection
- Support for multiple registration types (factory, singleton, lazySingleton, async variants)
- Automatic constructor parameter detection
- Smart dependency resolution for class dependencies
- Named parameter generation for primitive types
- Source directory code generation (`.g.dart` files)
- Integration with GetIt for dependency injection
- Comprehensive documentation and examples

### Features
- **Lazy Loading by Default**: Dependencies are created only when accessed
- **Fast App Startup**: No waiting for unused services to initialize
- **Memory Efficient**: Services exist only when needed
- **Smart Detection**: Automatically figures out what your classes need
- **One Annotation**: Just add `@AutoRegister()` and you're done
- **Flutter Ready**: Works seamlessly with Flutter and GetIt

### Technical Details
- Built with `build_runner` and `source_gen`
- Uses Dart analyzer for code analysis
- Generates optimized GetIt integration code
- Supports all Dart 3.0+ features
- Clean architecture compliant
