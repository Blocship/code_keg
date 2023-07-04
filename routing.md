<!-- 
Title: Flutter: type-safe routing

# Author: [Hashir Shoaib](https://twitter.com/hashirshoaeb)
# Site: https://hashirshoaeb.com
# Date: 2020-05-20 17:00:00
# Tags: flutter, dart, routing, navigation, type-safe, type safe, type safety, type-safety, type safety in flutter, type safe routing in flutter, flutter development, flutter development company, flutter development services, flutter development agency, flutter development agency,
 -->

```dart
class RoutePath {
  final String name;
  final RoutePath? child;

  RoutePath(
    this.name, {
    this.child,
  });

  RoutePath operator /(String name) {
    final path = RoutePath(name);
    if (child == null) {
      return copyWith(child: path);
    } else {
      return _trevor(root: this, path: path);
    }
  }

  RoutePath _trevor({required RoutePath root, required RoutePath path}) {
    if (root.child != null) {
      return root.copyWith(
        name: root.name,
        child: _trevor(
          root: root.child!,
          path: path,
        ),
      );
    } else {
      return root.copyWith(child: path);
    }
  }

  RoutePath copyWith({
    String? name,
    RoutePath? child,
  }) {
    return RoutePath(
      name ?? this.name,
      child: child ?? this.child,
    );
  }

  String get path => child != null ? '$name/${child!.path}' : name;

  bool get isRoot => child == null;

  static RoutePath get splash => RoutePath("/");
  static RoutePath get intro => RoutePath("/intro");
  static RoutePath get getStarted => RoutePath("/getStarted");
  static RoutePath get personalInformation =>
      getStarted / "personalInformation";
  static RoutePath get addressInformation =>
      personalInformation / "addressInformation";
  static RoutePath get home => addressInformation / "home";
}

void main() {
  print(RoutePath.splash.path);
  print(RoutePath.splash.isRoot);
  print(RoutePath.intro.path);
  print(RoutePath.intro.isRoot);
  print(RoutePath.getStarted.path);
  print(RoutePath.getStarted.isRoot);
  print(RoutePath.personalInformation.path);
  print(RoutePath.personalInformation.isRoot);
  print(RoutePath.addressInformation.path);
  print(RoutePath.addressInformation.isRoot);
  print(RoutePath.home.path);
  print(RoutePath.home.isRoot);
}
```