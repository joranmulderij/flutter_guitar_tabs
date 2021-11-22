library flutter_guitar_tabs;

import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlutterGuitarTab extends StatelessWidget {
  /// The name of the chord. This is only displayed at the top.
  final String name;

  /// A string containing up to 6 numbers, or `x`, with separating spaces.
  final String tab;

  /// The size of the tab. Has to be between 1 and 10 inclusive. Defaults to 9.
  final int size;

  /// The color of the tab. Defaults to `Colors.black`.
  final Color color;

  FlutterGuitarTab({this.name = '', required this.tab, this.size = 9, this.color = Colors.black, Key? key})
      : super(key: key) {
    assert(
        size <= 10 && size >= 1, 'Size has to be between 1 and 10 inclusive.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: [15.0, 18.0, 18.0, 24.0, 24.0, 24.0, 24.0, 24.0, 24.0, 28.0][size - 1],
              fontWeight: FontWeight.bold),
        ),
        Container(
          height: [
            30,
            45.0,
            50.0,
            70.0,
            90.0,
            110.0,
            130.0,
            130.0,
            150.0,
            160.0
          ][size - 1] as double?,
          width: [
            35,
            55.0,
            72.0,
            90.0,
            107.0,
            127.0,
            145.0,
            166.0,
            180.0,
            197.0
          ][size - 1] as double?,
          child: CustomPaint(
            painter: _MyPainter(tab, '', size: size, color: color),
          ),
        ),
      ],
    );
  }
}

/// A widget to display guitar tabs.
/// The widget TabWidget receives two parameters, `name` and `tabs`.
/// `name` is the name displayed on the top.
/// `tabs` is a list of strings containing up to 6 numbers, or `x`, with seperating spaces.
class TabWidget extends StatefulWidget {
  /// The name of the chord. This is only displayed at the top.
  final String name;

  /// A list of strings containing up to 6 numbers, or `x`, with seperating spaces.
  final List<String> tabs;

  /// The size of the tab. Has to be between 1 and 10 inclusive. Defaults to 9.
  final int size;

  /// The color of the tab. Defaults to `Colors.black`.
  final Color color;

  TabWidget({required this.name, required this.tabs, this.size = 9, this.color = Colors.black, Key? key})
      : super(key: key);

  @override
  _TabWidgetState createState() => _TabWidgetState(name, tabs, size: size);
}

class _Renderer {
  final Function(dynamic x, dynamic y, String? text, String? font, dynamic size)?
      text;
  final Function(dynamic x, dynamic y, dynamic r, bool fill,
      [dynamic lineWidth])? circle;
  final Function(
      dynamic x1, dynamic y1, dynamic x2, dynamic y2, dynamic lineWidth)? rect;
  final Function(dynamic startX, dynamic startY, dynamic endX, dynamic endY,
      dynamic lineWidth)? line;

  _Renderer({this.text, this.circle, this.line, this.rect});
}

class _TabWidgetState extends State<TabWidget> {
  final String name;
  final length;
  int index = 0;
  final List<String> tabs;
  final int? size;

  _TabWidgetState(this.name, this.tabs, {this.size}) : length = tabs.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IndexedStack(
          index: index,
          children: tabs
              .map(
                (e) => FlutterGuitarTab(
                  tab: e,
                  name: name,
                  size: size!,
                  color: widget.color,
                ),
              )
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    index = (index - 1) % length as int;
                  });
                }),
            Text('${index + 1} / $length'),
            IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    index = (index + 1) % length as int;
                  });
                }),
          ],
        ),
      ],
    );
  }
}

class _MyPainter extends CustomPainter {
  final Paint myPaint;
  _Renderer? renderer;
  late Canvas currentCanvas;
  String? name;
  String? rawPositions;
  String? rawFingers;
  late List<int?> positions;
  int? stringCount;
  late int fretCount;
  late List<int?> fingerings;
  int? startFret;
  final yOffset;
  final int size;

  _MyPainter(String positions, String fingers, {required this.size, required Color color})
      : yOffset = [10, 15, 20, 20, 20, 20, 30, 33, 35, 40][size - 1],
      myPaint = Paint()
    ..color = color
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke {
    this.parse(positions, fingers);
    this.rawPositions = positions;
    this.rawFingers = fingers;
    renderer = _Renderer(
      text: (dynamic x, dynamic y, String? text, String? font, dynamic size) {},
      circle: (dynamic x, dynamic y, dynamic r, bool fill,
          [dynamic lineWidth]) {
        if (fill) {
          currentCanvas.drawCircle(
              Offset(x.toDouble(), y.toDouble() - yOffset.toDouble()),
              r,
              myPaint..style = PaintingStyle.fill);
        } else {
          currentCanvas.drawCircle(
              Offset(x.toDouble(), y.toDouble() - yOffset.toDouble()),
              r,
              myPaint..style = PaintingStyle.stroke);
        }
      },
      rect:
          (dynamic x1, dynamic y1, dynamic x2, dynamic y2, dynamic lineWidth) {
        currentCanvas.drawRect(
            Rect.fromLTWH(x1.toDouble(), y1.toDouble() - yOffset.toDouble(),
                x2.toDouble(), y2.toDouble()),
            myPaint..style = PaintingStyle.fill);
      },
      line: (dynamic startX, dynamic startY, dynamic endX, dynamic endY,
          dynamic lineWidth) {
        currentCanvas.drawLine(
            Offset(startX.toDouble(), startY.toDouble() - yOffset.toDouble()),
            Offset(endX.toDouble(), endY.toDouble() - yOffset.toDouble()),
            myPaint..strokeWidth = lineWidth);
      },
    );
  }

  parse(String frets, String fingers) {
    this.positions = [];
    var raw = [];
    if (frets.contains(RegExp(r"^[0-9xX]{1,6}$"))) {
      for (var i = 0; i < frets.length; i++) {
        raw.add(frets[i]);
      }
    } else {
      raw = frets.split(' ');
    }
    this.stringCount = raw.length;
    if (this.stringCount == 4) {
      this.fretCount = 4;
    } else {
      this.fretCount = 5;
    }
    var maxFret = 0;
    var minFret = 1000;

    for (var i in raw) {
      var c = i;
      if (c.toLowerCase() == 'x') {
        this.positions.add(null);
      } else {
        var fret = int.parse(c);
        if (fret > 0 && fret < minFret) {
          minFret = fret;
        }
        maxFret = math.max(maxFret, fret);
        this.positions.add(fret);
      }
    }
    if (maxFret <= this.fretCount) {
      this.startFret = 1;
    } else {
      this.startFret = minFret;
    }
    this.fingerings = [];
    var j = 0;
    for (var i = 0; i < fingers.length; i++) {
      for (; j < this.positions.length; j++) {
        if (this.positions[j]! <= 0) {
          this.fingerings.add(null);
        } else {
          this.fingerings.add(int.parse(fingers[i]));
          j++;
          break;
        }
      }
    }
  }

  drawMutedAndOpenStrings(info) {
    var r = this.renderer;
    for (int i = 0; i < this.positions.length; i++) {
      var pos = this.positions[i];
      var x = info['boxStartX'] + i * info['cellWidth'];
      var y = info['nameFontSize'] +
          info['nameFontPaddingBottom'] +
          info['dotRadius'] -
          2;
      if (this.startFret! > 1) {
        y += info['nutSize'];
      }
      if (pos == null) {
        this.drawCross(
            info, x, y, info['muteStringRadius'], info['muteStringLineWidth']);
      } else if (pos == 0) {
        r!.circle!(
            x, y, info['openStringRadius'], false, info['openStringLineWidth']);
      }
    }
  }

  drawPositions(info) {
    var r = this.renderer;
    for (int i = 0; i < this.positions.length; i++) {
      var pos = this.positions[i] ?? 0;
      if (pos > 0) {
        var relativePos = pos - this.startFret! + 1;
        var x = info['boxStartX'] + i * info['cellWidth'];
        if (relativePos <= 5) {
          var y = info['boxStartY'] +
              relativePos * info['cellHeight'] -
              (info['cellHeight'] / 2);
          r!.circle!(x, y, info['dotRadius'], true);
        }
      }
    }
  }

  drawFretGrid(info) {
    var r = this.renderer;
    var width = (this.stringCount! - 1) * info['cellWidth'];
    for (var i = 0; i <= this.stringCount! - 1; i++) {
      var x = info['boxStartX'] + i * info['cellWidth'];
      r!.line!(
          x,
          info['boxStartY'],
          x,
          info['boxStartY'] + this.fretCount * info['cellHeight'],
          info['lineWidth']);
    }

    for (var i = 0; i <= this.fretCount; i++) {
      var y = info['boxStartY'] + i * info['cellHeight'];
      r!.line!(info['boxStartX'], y, info['boxStartX'] + width, y,
          info['lineWidth']);
    }
  }

  drawNut(info) {
    var r = this.renderer;
    if (this.startFret == 1) {
      r!.rect!(info['boxStartX'], info['boxStartY'] - info['nutSize'],
          info['boxWidth'], info['nutSize'], info['lineWidth']);
    } else {
      r!.text!(
          info['boxStartX'] - info['dotRadius'],
          info['boxStartY'] + info['cellHeight'] / 2.0,
          this.startFret.toString(),
          info['font'],
          info['fretFontSize']);
    }
  }

  drawName(info) {
    var r = this.renderer!;
    r.text!(info['width'] / 2.0, info['nameFontSize'] + info['lineWidth'] * 3,
        this.name, info['font'], info['nameFontSize']);
  }

  //It's better to specify this explicitly. Trying to scale in a nice way to doesn't works so well.
  Map<String, List<double>> sizes = {
    "cellWidth": [4, 6, 8, 10, 12, 14, 16, 18, 20, 22],
    "nutSize": [2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
    "lineWidth": [1, 1, 1, 1, 1, 1, 2, 2, 2, 2],
    "barWidth": [2.5, 3, 5, 7, 7, 9, 10, 10, 12, 12],
    "dotRadius": [2, 2.8, 3.7, 4.5, 5.3, 6.5, 7, 8, 9, 10],
    "openStringRadius": [1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6.5],
    "openStringLineWidth": [1, 1.2, 1.2, 1.4, 1.4, 1.4, 1.6, 2, 2, 2],
    "muteStringRadius": [2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5],
    "muteStringLineWidth": [1.05, 1.1, 1.1, 1.2, 1.5, 1.5, 1.5, 2, 2.4, 2.5],
    "nameFontSize": [10, 14, 18, 22, 26, 32, 36, 40, 44, 48],
    "nameFontPaddingBottom": [4, 4, 5, 4, 4, 4, 5, 5, 5, 5],
    "fingerFontSize": [7, 8, 9, 11, 13, 14, 15, 18, 20, 22],
    "fretFontSize": [6, 8, 10, 12, 14, 14, 16, 17, 18, 19]
  };

  calculateDimensions(scale) {
    Map<String, dynamic> info = {};
    scale--;
    for (var name in this.sizes.keys) {
      info[name] = this.sizes[name]![scale];
    }

    info['scale'] = scale;
    info['positions'] = this.rawPositions;
    info['fingers'] = this.rawFingers;
    info['name'] = this.name;
    info['cellHeight'] = info['cellWidth'];
    info['dotWidth'] = 2 * info['dotRadius'];
    info['font'] = 'Arial';
    info['boxWidth'] = (this.stringCount! - 1) * info['cellWidth'];
    info['boxHeight'] = (this.fretCount) * info['cellHeight'];
    info['width'] = info['boxWidth'] + 4 * info['cellWidth'];
    info['height'] = info['nameFontSize'] +
        info['nameFontPaddingBottom'] +
        info['dotWidth'] +
        info['nutSize'] +
        info['boxHeight'] +
        info['fingerFontSize'] +
        4;
    info['boxStartX'] = ((info['width'] - info['boxWidth']) / 2).toInt();
    info['boxStartY'] = (info['nameFontSize'] +
            info['nameFontPaddingBottom'] +
            info['nutSize'] +
            info['dotWidth'])
        .toInt();
    return info;
  }

  draw(scale) {
    var info = this.calculateDimensions(scale);
    this.drawFretGrid(info);
    this.drawNut(info);
    this.drawName(info);
    this.drawMutedAndOpenStrings(info);
    this.drawPositions(info);
    this.drawFingerings(info);
    this.drawBars(info);
  }

  drawBars(info) {
    var r = this.renderer;
    if (this.fingerings.length > 0) {
      var bars = {};
      for (var i = 0; i < this.positions.length; i++) {
        var fret = this.positions[i] ?? 0;
        if (fret > 0) {
          if (bars[fret] && bars[fret].finger == this.fingerings[i]) {
            bars[fret].length = i - bars[fret]['index'];
          } else {
            bars[fret] = {
              "finger": this.fingerings[i],
              "length": 0,
              "index": i
            };
          }
        }
      }
      for (var fret in bars.keys) {
        if (bars[fret].length > 0) {
          var xStart =
              info['boxStartX'] + bars[fret]['index'] * info['cellWidth'];
          var xEnd = xStart + bars[fret]['length'] * info['cellWidth'];
          var relativePos = fret - this.startFret + 1;
          var y = info['boxStartY'] +
              relativePos * info['cellHeight'] -
              (info['cellHeight'] / 2);
          //console.log('y: ' + y + ', barWidth: ' + info.barWidth);
          r!.line!(xStart, y, xEnd, y, info['barWidth']);
        }
      }

      //Explicit, calculate from that
    } else {
      //Try to guesstimate whether there is a bar or not
      var barFret = this.positions[this.positions.length - 1]!;
      if (barFret <= 0) {
        return;
      }
      if (this.positions.join('') == '-1-10232') {
        //Special case for the D chord...
        return;
      }
      var startIndex = -1;

      for (var i = 0; i < this.positions.length - 2; i++) {
        var fret = this.positions[i] ?? 0;
        if (fret > 0 && fret < barFret) {
          return;
        } else if (fret == barFret && startIndex == -1) {
          startIndex = i;
        } else if (startIndex != -1 && fret < barFret) {
          return;
        }
      }
      if (startIndex >= 0) {
        var xStart = info['boxStartX'] + startIndex * info['cellWidth'];
        var xEnd = (this.positions.length - 1) * info['cellWidth'];
        var relativePos = barFret - this.startFret! + 1;
        var y = info['boxStartY'] +
            relativePos * info['cellHeight'] -
            (info['cellHeight'] / 2);
        r!.line!(xStart, y, xEnd, y, info['dotRadius']);
      }
    }
  }

  drawCross(info, x, y, radius, lineWidth) {
    var r = this.renderer;
    var angle = math.pi / 4;
    for (var i = 0; i < 2; i++) {
      var startAngle = angle + i * math.pi / 2;
      var endAngle = startAngle + math.pi;

      var startX = x + radius * math.cos(startAngle);
      var startY = y + radius * math.sin(startAngle);
      var endX = x + radius * math.cos(endAngle);
      var endY = y + radius * math.sin(endAngle);

      r!.line!(startX, startY, endX, endY, lineWidth);
    }
  }

  drawFingerings(info) {
    var r = this.renderer;
    var fontSize = info['fingerFontSize'];
    for (var i in this.fingerings) {
      var finger = i;
      var x = info['boxStartX'] + i! * info['cellWidth'];
      var y = info['boxStartY'] +
          info['boxHeight'] +
          fontSize +
          info['lineWidth'] +
          1;
      if (finger != null) {
        r!.text!(x, y, finger.toString(), info['font'], fontSize);
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    currentCanvas = canvas;
    draw(this.size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
