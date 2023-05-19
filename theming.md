<!-- # Title: Revolutionizing Theming in Flutter: A New Approach for Better UI Consistency

# Author: [Hashir Shoaib](https://twitter.com/hashirshoaeb)
# Site: https://hashirshoaeb.com
# Date: 2020-05-20 17:00:00
# Tags: flutter, dart, theming, ui, consistency, design, development, mobile, app, android, ios, cross-platform, crossplatform, cross platform, flutter development, flutter development company, flutter development services, flutter development agency, flutter development agency,

[Image](https://hashirshoaeb.com/assets/images/blog/revolutionizing-theming-in-flutter-a-new-approach-for-better-ui-consistency/cover.png) -->


# Introduction: What is Theming in Flutter?

Theming is a crucial aspect of developing high-quality mobile applications, and it's no different in Flutter. In Flutter, the ThemeData class is used to define the app's theme. This class includes properties for colors, fonts, shapes, and other visual elements, which can be customized to fit your app's specific needs. By using the ThemeData class, developers can easily create and modify themes, making it a powerful tool for building great-looking apps with minimal effort.

# Challenges of Implementing Dual Themes in Flutter App

Implementing themes in Flutter can greatly enhance the visual appeal and consistency of apps. However, it's important to be aware of certain limitations that can arise when working with ThemeData, the primary API for theming in Flutter. Here are some of the challenges I encountered during my exploration:

1. **Coupling with Material Widgets:** ThemeData is closely tied to Material Widgets and MaterialApp. While the introduction of the extension API allows for some extension of theme data, it may not provide sufficient flexibility in all scenarios.
2. **Dependency on ThemeData:** I found that it is not possible to completely replace the ThemeData class with a custom class. To leverage the full capabilities of Material Widgets, reliance on ThemeData is necessary, which can restrict customization options.
3. **Optional Properties:** While the optional nature of ThemeData properties offers flexibility, it also presents a challenge. There is no built-in mechanism to enforce the initialization of specific properties, which can lead to inconsistencies or errors in the multi theme setup.
4. **Single Theme Property:** One notable limitation of ThemeData is the restriction to defining only one theme property. This means that if there is a need for multiple themes, such as different styles for floating action buttons, ThemeData falls short as it allows for the definition of only a single theme.

By recognizing these limitations, I was motivated to explore alternative approaches and develop a new theming implementation that overcomes these challenges and provides a more flexible and customizable solution.

# Introduction to New Theming Approach

To address the limitations mentioned earlier, I have developed a new and straightforward approach.

The key to this approach is encapsulating the ThemeData class within a custom class and utilizing abstract properties. These abstract properties can encompass both the default ThemeData properties and any additional custom theme properties we desire.

By utilizing abstract properties, we ensure that the necessary properties are initialized and defined in each specific implementation of the custom class. This enforcement promotes consistency and reduces the risk of errors during the theming process.

By leveraging the abstract properties to define the ThemeData class in base custom class, we gain the ability to create distinct themes with unique configurations without the need to override the ThemeData class in implementing classes. Developers can customize various aspects of the theme, such as colors, typography, and more, based on their specific app requirements.

With this new theming approach, developers can achieve a higher level of flexibility and control, allowing for the creation of multiple theme variations within a single app. By providing a structured and enforceable way to define theme properties.

In the following sections, I will provide concrete examples and code snippets to demonstrate the implementation and usage of this new theming approach in Flutter.


Create a wrapper class to encapsulate the ThemeData class. This class will be used to define the theme for your app. 

```dart
abstract class AppTheme {
  ThemeData get themeData {
    return ThemeData();
  }
}
```

Create and add abstract property to the wrapper class to define the theme properties.

```dart
class ColorTheme extends ThemeExtension<ColorTheme> {
  final Color primaryColor;
  final Color secondaryColor;

  ColorTheme({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  ThemeExtension<ColorTheme> copyWith({
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return ColorTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
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
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t)!,
    );
  }
}
```

Now the updated AppTheme class will look like this:

```dart
abstract class AppTheme {
  ColorTheme get colorTheme;
  Brightness get brightness;

  ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: colorTheme.primaryColor,
      brightness: brightness,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorTheme.secondaryColor,
      ),
      extensions: [
        colorTheme,
      ],
    );
  }
}
```

Now, we can create a new class that extends the AppTheme class and implements the abstract properties.

```dart
class LightTheme extends AppTheme {
  @override
  final ColorTheme colorTheme = ColorTheme(
    primaryColor: Colors.indigo.shade50,
    secondaryColor: Colors.black,
  );

  @override
  final Brightness brightness = Brightness.light;
}

class DarkTheme extends AppTheme {
  @override
  final ColorTheme colorTheme = ColorTheme(
    primaryColor: Colors.indigo.shade700,
    secondaryColor: Colors.white,
  );

  @override
  final Brightness brightness = Brightness.dark;
}
```

Finally, we can use the themeData property to access the ThemeData class and apply the theme to our app.

```dart
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode mode;

  @override
  void initState() {
    super.initState();
    // Initializing the theme mode as light
    mode = ThemeMode.light;
  }

  // Toggling the theme mode between light and dark
  void onThemeChanged() {
    setState(() {
      mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Using the LightTheme's themeData as the default theme
      theme: LightTheme().themeData,
      // Using the DarkTheme's themeData as the dark theme
      darkTheme: DarkTheme().themeData,
      // Setting the current theme mode
      themeMode: mode,
      home: MyHomePage(onChanged: onThemeChanged),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final void Function() onChanged;
  const MyHomePage({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Accessing the scaffold background color from the current theme
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        // Accessing the secondary color from the current theme's color theme extension
        backgroundColor: context.colorTheme.secondaryColor,
      ),
      body: Center(
        child: Text(
          'Hello, ${Theme.of(context).brightness.name} Themed World!',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onChanged,
        child: Icon(
          Icons.brightness_4,
          // Accessing the primary color from the current theme's color theme extension
          color: context.colorTheme.primaryColor,
        ),
      ),
    );
  }
}
```

```dart
extension XBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorTheme get colorTheme => theme.extension<ColorTheme>()!;
}
```

# Conclusion

In this article, I have introduced a new approach to theming in Flutter that provides a more flexible and customizable solution. By encapsulating the ThemeData class within a custom class and utilizing abstract properties, we can create distinct themes with unique configurations without the need to override the ThemeData class in implementing classes. This approach also allows for the creation of multiple theme variations within a single app, providing a structured and enforceable way to define theme properties.