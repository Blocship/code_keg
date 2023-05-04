<!-- # Title: Revolutionizing Theming in Flutter: A New Approach for Better UI Consistency

# Author: [Hashir Shoaib](https://twitter.com/hashirshoaeb)
# Site: https://hashirshoaeb.com
# Date: 2020-05-20 17:00:00
# Tags: flutter, dart, theming, ui, consistency, design, development, mobile, app, android, ios, cross-platform, crossplatform, cross platform, flutter development, flutter development company, flutter development services, flutter development agency, flutter development agency,

[Image](https://hashirshoaeb.com/assets/images/blog/revolutionizing-theming-in-flutter-a-new-approach-for-better-ui-consistency/cover.png) -->


# Introduction: What is Theming in Flutter?

Theming is a crucial aspect of developing high-quality mobile applications, and it's no different in Flutter. In Flutter, the ThemeData class is used to define the app's theme. This class includes properties for colors, fonts, shapes, and other visual elements, which can be customized to fit your app's specific needs. By using the ThemeData class, developers can easily create and modify themes, making it a powerful tool for building great-looking apps with minimal effort.

# Challenges of Implementing Dual Themes in Flutter App

While implementing themes in Flutter can be a powerful tool for creating consistent and visually appealing apps, it also comes with its own set of challenges. Here are some of the common challenges that developers may face when working with themes in Flutter:

1. In ThemeData the properties are nullable. So if developer is creating 2 instances of ThemeData, one for light theme and one for dark theme, then he/she can easily forget to set some properties in one of the instances. This can lead to inconsistent UI.

```dart
final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  accentColor: Colors.black,
  brightness: Brightness.light,
);

final ThemeData darkTheme = ThemeData(
  // i can forget to set primaryColor here  
  // primaryColor: Colors.black,
  accentColor: Colors.white,
  brightness: Brightness.dark,
);
```


2. ThemeData is for Material Widgets only. So if developer is using some custom widgets, then he/she has to create a separate theme for those widgets. Developer could easily forget to add theme extension methods in one of the instances of ThemeData. 


```dart
final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  accentColor: Colors.black,
  brightness: Brightness.light,
  extensions: [
    ColorTheme(
        primary: Colors.white,
        secondary: Colors.black,
        ),
  ],
);

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  accentColor: Colors.white,
  brightness: Brightness.dark,
  extensions: [
    // i can forget to add ColorTheme extension here  
  ],
);
```

3. ThemeData allows you to define only one theme for the whole app. So if developer wants to have different themes for different set of screens, then he/she has to create a separate theme for each screen. Then developer has to override the theme using copyWith method. This can lead to a lot of boilerplate code. 

```dart

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  accentColor: Colors.black,
  brightness: Brightness.light,
);


final ThemeData lightThemeForScreen1 = lightTheme.copyWith(
  primaryColor: Colors.red,
  accentColor: Colors.blue,
);

```

# Introduction to New Theming Approach

In this article, I will introduce a new approach for theming in Flutter. This approach will help you to solve all the above-mentioned challenges. This approach will also help you to create consistent UI in your Flutter app. 


Define your color theme extension class. This class will be used to define the color theme for your app. 

```dart

class ColorTheme extends ThemeExtension<ColorTheme> {
  final Color primaryColor;

  ColorTheme({
    required this.primaryColor,
  });

 @override
  ThemeExtension<ColorTheme> copyWith({
    Color? primaryColor,
  }) {
    return ColorTheme(
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }

  @override
  ThemeExtension<ColorTheme> lerp(
    covariant ThemeExtension<ColorTheme>? other,
    double t,
  ) {
    if (other is! ColorTheme) {
      return this;
    }
    return ColorTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
    );
  }
}

```

Create a wrapper over ThemeData class. This wrapper will be used to define the theme for your app. 

```dart
abstract class AppTheme {
  ColorTheme get colorTheme;

  ThemeData get themeData {
    return ThemeData(
      primaryColor: colorTheme.primaryColor,
      extensions: [
        colorTheme,
        ],
    );
  }
}

```

Create Implementation of AppTheme. 

```dart
class LightTheme extends AppTheme {
  @override
  final ColorTheme colorTheme = ColorTheme(
    primaryColor: Colors.white,
  );
}

class DarkTheme extends AppTheme {
  @override
  final ColorTheme colorTheme = ColorTheme(
    primaryColor: Colors.black,
  );
}

```

How to use this approach in your app? 


```dart


final AppTheme lightTheme = LightTheme();
final AppTheme darkTheme = DarkTheme();
final ThemeData lightThemeData = lightTheme.themeData;
final ThemeData darkThemeData = darkTheme.themeData;

MaterialApp(
  theme: lightThemeData,
  darkTheme: darkThemeData,
  themeMode: ThemeMode.system,
  home: HomeScreen(),
);

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTheme = context.colorTheme.primaryColor;
    final theme = context.theme;
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: colorTheme.primaryColor,
      ),
    );
  }
}

extension XBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorTheme get colorTheme => theme.extension<ColorTheme>()!;
}


```
