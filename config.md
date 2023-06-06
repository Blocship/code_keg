<!-- 
Title: App configuration in Flutter based on flavor / environment

# Author: [Hashir Shoaib](https://twitter.com/hashirshoaeb)
# Site: https://hashirshoaeb.com
# Tags: flutter, dart, app configuration, app config, app config in flutter, app configuration in flutter, flutter development, flutter development company, flutter development services, flutter development agency, flutter development agency,
 -->

# Introduction
In any application, it is common to have different configurations for different environments such as development, staging, and production. Managing these configurations effectively is crucial to ensure a smooth development process and to easily switch between environments. In this blog post, we will explore an implementation of app configuration using enums and extensions in Flutter.

# App configuration
App configuration is a set of values that are used to configure the app based on the current environment. For example, the base URL of the API, the API keys for third-party services, etc. The app configuration is usually different for different environments. For example, the base URL of the API will be different for the development environment and the production environment.

# Implementation
We will use enums and extensions to implement app configuration in Flutter. The enum will represent the different environments of the app. The extension will be used to map different values based on the current environment.

```dart
/// Represents the environment of the app.
enum Environment {
  qa,
  prod;

  factory Environment.from(String env) {
    switch (env) {
      case 'prod':
        return Environment.prod;
      case 'qa':
        return Environment.qa;
      default:
        throw UnimplementedError('Environment $env is not implemented');
    }
  }
}
```

The `Environment` enum represents the different environments of the app. The `Environment.from` factory constructor is used to create an instance of `Environment` from a string. This is useful when the environment is set using the `--dart-define` flag in the run command.

```dart
/// Holds the current environment of the app.
/// This is set by dart define flag `--dart-define=flavor=qa` in the run command.
/// The default value is `qa`.
final Environment kEnvironment = Environment.from(
  const String.fromEnvironment('flavor', defaultValue: 'qa'),
);
```

The `kEnvironment` variable holds the current environment of the app. This is set by the `--dart-define` flag in the run command. The default value is `qa`.

```dart
/// Holds the current app config.
/// Returns the correct config based on the current environment.
abstract class AppConfig {

  String get baseUrl;
  Environment get environment;

  /// Factory constructor to create an instance of [AppConfig]
  /// based on the current environment.
  factory AppConfig() {
    return kEnvironment.map(
      prod: () => _ProdAppConfig(),
      staging: () => _StagingAppConfig(),
    );
  }
}
```

The `AppConfig` abstract class holds the current app configuration. It includes a factory constructor that returns an instance of the appropriate implementation based on the kEnvironment value.

```dart
class _ProdAppConfig implements AppConfig {
  @override
  final Environment environment = Environment.prod;
  @override
  final String baseUrl = 'https://api.example.com';
}

class _StagingAppConfig implements AppConfig {
  @override
  final Environment environment = Environment.qa;
  @override
  final String baseUrl = 'https://api.example.com';
}
```

The `_ProdAppConfig` and `_StagingAppConfig` classes are the implementations of the `AppConfig` abstract class. They hold the configuration values for the production and staging environments respectively.

```dart
extension XEnvironment on Environment {
  bool get isProd => this == Environment.prod;
  bool get isStaging => this == Environment.qa;

  void maybeWhen({
    Function()? prod,
    Function()? staging,
    Function()? orElse,
  }) {
    switch (this) {
      case Environment.prod:
        prod?.call() ?? orElse?.call();
        break;
      case Environment.qa:
        staging?.call() ?? orElse?.call();
        break;
    }
  }

  /// The [map] method allows mapping different values
  ///  based on the current environment.
  T map<T>({
    required T Function() prod,
    required T Function() staging,
  }) {
    switch (this) {
      case Environment.prod:
        return prod();
      case Environment.qa:
        return staging();
    }
  }
}
```

The `XEnvironment` extension on the `Environment` enum adds some useful methods. The `isProd` and `isStaging` getters return true if the current environment is production or staging respectively. The `maybeWhen` method is similar to the `when` method of the `freezed` package. It allows executing a function based on the current environment. The `map` method allows mapping different values based on the current environment.