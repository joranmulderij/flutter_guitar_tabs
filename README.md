# flutter_guitar_tabs

This is a dart implementation of the [chord.js](https://github.com/einaregilsson/chord.js) javascript package to display beautiful chord diagrams like the ones below.

![Example 1](https://raw.githubusercontent.com/joranmulderij/flutter_guitar_tabs/main/images/example1.png)
![Example 2](https://raw.githubusercontent.com/joranmulderij/flutter_guitar_tabs/main/images/example2.png)
![Example 3](https://raw.githubusercontent.com/joranmulderij/flutter_guitar_tabs/main/images/example3.png)

## `FlutterGuitarTab`

The widget `FlutterGuitarTab` takes two parameters, `name` and `tab`.
`name` is the name displayed on the top.
`tab` string containing up to 6 numbers, or `x`, with seperating spaces.
As an example:

- `"x 0 0 2 3 1"`
- `"x 5 7 7 6 5"`
- `"10 12 12 10 10 10"`

An example of how to use this widget:

```dart
FlutterGuitarTab(
  name: 'Dm',
  tab: 'x 0 0 2 3 1',
)
```

## `TabWidget`

The widget `TabWidget` takes two parameters, `name` and `tabs`.
`name` is the name displayed on the top.
`tabs` is a list of strings containing tab strings as explained above.

This is an example of how to use this widget:

```dart
TabWidget(
  name: 'Dm',
  tabs: ["x 0 0 2 3 1", "x 5 7 7 6 5", "10 12 12 10 10 10"],
)
```

## Todo:

- Add support for fingering marks.
- Different sizes.

PR's are welcome.

