# DI Generator Build Example

This example demonstrates how to use the `di_generator_build` package to automatically generate dependency injection code.

## 🚀 Quick Run

1. **Install dependencies:**
   ```bash
   dart pub get
   ```

2. **Generate code:**
   ```bash
   dart run build_runner build
   ```

3. **Run the example:**
   ```bash
   dart run example.dart
   ```

## 📁 What You'll See

The example shows:
- **LoggerService**: Simple service with no dependencies
- **UserRepository**: Repository that simulates API calls
- **UserService**: Service that depends on other services
- **ConfigService**: Service with configuration parameters
- **AsyncService**: Service with async initialization

## 🔍 Key Benefits Demonstrated

- **Lazy Loading**: Services are created only when needed
- **Fast Startup**: App starts quickly without loading unused services
- **Memory Efficient**: Services exist only when accessed
- **Automatic DI**: No manual dependency registration needed

## 🛠️ Try It Yourself

1. Modify the services in `example.dart`
2. Run `dart run build_runner watch` to auto-generate code
3. See how the generated `.g.dart` files change automatically

This example shows the power of lazy dependency injection - your app only loads what it actually needs! 🎯
