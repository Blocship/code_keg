```dart
/// Represents the environment of the app.
/// - [prod] for production
/// - [qa] for staging and dev testing
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

/// Holds the current environment of the app.
/// This is set by dart define flag `--dart-define=flavor=qa` in the run command.
/// The default value is `qa`.
final Environment kEnvironment = Environment.from(
  const String.fromEnvironment('flavor', defaultValue: 'qa'),
);

/// Holds the current app config.
/// Returns the correct config based on the current environment.
abstract class AppConfig {
  static String cryptoSecretKey = '3Ddt6vQm63FybcjePBDHtCBQQUtfKYO7';
  static String cryptoSecretIV = 'Ywn1DasculiznB1P';
  String get baseUrl;
  String get oneSignalAppId;
  String get uxCamAppKey;
  String get mixPanelToken;
  String get freshChatAppKey;
  String get freshChatAppId;
  String get freshChatAppDomain;
  String get rollbarAccessToken;
  String get rollbarPackage;
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