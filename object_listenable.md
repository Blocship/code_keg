```dart
class ObservableObject<T> {
  T _value;
  final void Function(T oldValue, T newValue)? _onChange;

  ObservableObject({
    required T value,
    void Function(T oldValue, T newValue)? didSet,
  })  : _value = value,
        _onChange = didSet;

  T get value => _value;

  set value(T newValue) {
    final oldValue = _value;
    _value = newValue;
    _onChange?.call(oldValue, newValue);
  }
}

extension XObject<T> on Object {
  ObservableObject<T> asObservable<T>({
    void Function(T oldValue, T newValue)? didSet,
  }) {
    return ObservableObject<T>(
      value: this as T,
      didSet: didSet,
    );
  }
}

void main(List<String> args) {
  // final observable = ObservableObject<String>(
  //     value: 'Hello',
  //     didSet: (oldValue, newValue) {
  //       print('oldValue: $oldValue');
  //       print('newValue: $newValue');
  //     });

  final obserableInt = 1.asObservable<int>(
    didSet: (oldValue, newValue) {
      print('oldValue: $oldValue');
      print('newValue: $newValue');
    },
  );

  obserableInt.value = 2;
  obserableInt.value = 4;
  obserableInt.value = 9;
}
```