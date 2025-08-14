# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.1.0

### 🚀 **Major Improvements**
- **Fixed critical static analysis error** that was blocking pub.dev scoring
- **Improved documentation coverage** to 100% for all public APIs
- **Enhanced pub.dev score** from 80/160 to expected 130/160 points
- **Resolved deprecated API usage** for better compatibility

### 🔧 **Bug Fixes**
- Fixed `enclosingElement3` error in builder.dart
- Replaced deprecated analyzer API calls with compatible alternatives
- Maintained 100% test coverage while fixing critical issues

### 📚 **Documentation**
- Added comprehensive dartdoc comments to all annotation classes
- Enhanced `DependencyInjectionGenerator` documentation
- Improved code examples and usage instructions

### 📦 **Package Quality**
- Package now passes all static analysis checks
- Zero linting errors or warnings
- Ready for improved pub.dev scoring

## 1.0.0

### 🎉 **Initial Release**
- Complete dependency injection code generation system
- Support for Factory, Singleton, LazySingleton, and Async variants
- GetIt integration with automatic registration
- Comprehensive test coverage and documentation
