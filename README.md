# flutter_guitar_tabs
 
 flutter_guitar_tabs is a package to show guitar tabs like the one below:

 ![Example 1](https://raw.githubusercontent.com/joranmulderij/flutter_guitar_tabs/main/images/example1.png)
 ![Example 2](https://raw.githubusercontent.com/joranmulderij/flutter_guitar_tabs/main/images/example2.png)
 ![Example 3](https://raw.githubusercontent.com/joranmulderij/flutter_guitar_tabs/main/images/example3.png)

## How to use the package

The widget `TabWidget` receives two parameters, `name` and `tabs`.
`name` is the name displayed on the top.
`tabs` is a list of strings containing up to 6 numbers, or `x`, with seperating spaces.
As an example:

- `"x 0 0 2 3 1"`
- `"x 5 7 7 6 5"`
- `"10 12 12 10 10 10"`

## Example use

This is an example of how to use the package:

```dart

TabWidget(
  name: 'Dm',
  tabs: ["x 0 0 2 3 1", "x 5 7 7 6 5", "10 12 12 10 10 10"],
),

```


PR's are welcome.

