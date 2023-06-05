```dart
enum Environment { qa, prod }

final Environment kEnvironment =
    const String.fromEnvironment('flavor', defaultValue: 'qa').toEnv();

abstract class AppConfig {
  Environment get environment;
  String get baseUrl;

  factory AppConfig() {
    return kEnvironment.map(
      prod: () => _ProdAppConfig(),
      staging: () => _StagingAppConfig(),
    );
  }
}

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


extension _XString on String {
  Environment toEnv() {
    switch (this) {
      case 'prod':
        return Environment.prod;
      case 'qa':
        return Environment.qa;
      default:
        throw UnimplementedError('Environment $this is not implemented');
    }
  }
}

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