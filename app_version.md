Environment enum from [config.md](./config.md)

```dart
extension _XEnvironment on Environment {
  String get verisonSuffix {
    switch (this) {
      case Environment.qa:
        return '-qa';
      case Environment.prod:
        return '';
    }
  }
}
```

```dart

class VersionView extends StatelessWidget {
  final Future<PackageInfo> info;
  final Environment environment;
  final TextStyle? style;
  
  const VersionView({
    Key? key,
    required this.info,
    required this.environment,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: info,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final packageInfo = snapshot.data!;
        final version = packageInfo.version;
        final buildNumber = packageInfo.buildNumber;
        final versionSuffix = environment.verisonSuffix;
        return Text(
          'v$version$versionSuffix+$buildNumber',
          style: style ?? Theme.of(context).textTheme.caption,
        );
      },
    );
  }
}
```


