```dart
const debounce = (func, delay) => {
  let timer;
  return (...args) => {
    if (timer) clearTimeout(timer);
    timer = setTimeout(() => {
      func(...args);
    }, delay);
  };
};
// usage
const handleSearch = () => {
  // search request
};
const debouncedSearch = debounce(handleSearch, 500);
const handleChange = (e) => {
  debouncedSearch();
};
```

convert the above code to dart
```dart
Function debounce(Function func, int delay) {
  Timer timer;
  return ([List args]) {
    if (timer != null) timer.cancel();
    timer = Timer(Duration(milliseconds: delay), () {
      func(args);
    });
  };
}
// usage
void handleSearch() {
  // search request
}
final debouncedSearch = debounce(handleSearch, 500);
void handleChange(e) {
  debouncedSearch();
}
```