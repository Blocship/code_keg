<!-- 

# title: Simplifying Flutter Permission Requests with Dependency Wrapping

# description: A simple example of how to improve code modularity and simplify Flutter permission requests with a custom wrapper class for permission handling flutter.

# author: [Hashir Shoaib](https://twitter.com/hashirshoaeb)

# date: 2023-04-15
#tags: [flutter permissions, dependency wrapper, custom wrapper class, permission handling]
 -->

# Dependency Wrapping

Dependency wrapping is a software development technique where a layer of abstraction is added around a dependency, such as a third-party library or service, to make it easier to use and maintain.

# Why Use a Dependency Wrapper

The purpose of dependency wrapping is to isolate the details of the dependency from the rest of the codebase and make it easier to switch to a different implementation of the dependency if needed. By wrapping the dependency, developers can create a well-defined interface that is specific to their needs, rather than relying on the often complex and inconsistent API provided by the underlying dependency.

Dependency wrapping can also make it easier to test code, as it allows developers to create mock implementations of the wrapped dependency that can be used for testing. This can help to reduce the coupling between different parts of the codebase and improve overall code quality.

# Implementing the Wrapper Class

In Flutter, a common use case for dependency wrapping is when working with device permissions. Here is an example of how you could write a simple dependency wrapper for handling permissions in Flutter:

PermissionStatus to represent the status of a permission request.

```dart
enum PermissionStatus {
  granted,
  denied;
}
```

Extension methods to make it easier to check the status of a permission request.

```dart
extension XPermissionStatus on PermissionStatus {
  bool get isGranted => this == PermissionStatus.granted;
  bool get isDenied => this == PermissionStatus.denied;
}
```

An enum to represent the different types of permissions that we want to request.

```dart
enum _PermissionType {
  photos,
  notification,
}
```

The `Permission` abstract class is defined as a wrapper for the `permission_handler` package and other permission handling dependencies. It provides a factory constructor that creates instances of the Permission class for different permission types and static getters to access the different permissions.

The purpose of the Permission class is to provide a well-defined interface for permission handling that is specific to the app's needs, and to abstract away the underlying implementation details of the permission handling library / plugin.

```dart
abstract class Permission {
  static Permission photoGallery = Permission._(_PermissionType.photos);
  static Permission notification = Permission._(_PermissionType.notification);

  Permission();

  factory Permission._(_PermissionType type) {
    switch (type) {
      case _PermissionType.photos:
        return _ReadPhotoGalleryPermission();
      case _PermissionType.notification:
        return _NotificationPermission();
    }
  }

  Future<PermissionStatus> request();
  Future<PermissionStatus> status();

}
```

The `_ReadPhotoGalleryPermission` and `_NotificationPermission` classes are concrete implementations of the Permission class. They are responsible for handling the actual permission requests and status checks.

```dart
class _ReadPhotoGalleryPermission implements Permission {
  @override
  Future<PermissionStatus> request() async {
    // TODO: implement request
    throw UnimplementedError();
  }

  @override
  Future<PermissionStatus> status() async {
    // TODO: implement status
    throw UnimplementedError();
  }
}

class _NotificationPermission implements Permission {
  @override
  Future<PermissionStatus> request() async {
    // TODO: implement request
    throw UnimplementedError();
  }

  @override
  Future<PermissionStatus> status() async {
    // TODO: implement status
    throw UnimplementedError();
  }
}
```
