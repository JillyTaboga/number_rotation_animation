import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double value = 0;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NumberCountAnimated(
              value: value,
              boxDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 100,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Slider(
              value: value,
              divisions: 23,
              max: 100,
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NumberCountAnimated extends StatefulWidget {
  const NumberCountAnimated({
    super.key,
    required this.value,
    this.textStyle,
    this.boxDecoration,
    this.decorationPaddgin,
  });

  final double value;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final EdgeInsets? decorationPaddgin;

  @override
  State<NumberCountAnimated> createState() => _NumberCountAnimatedState();
}

class _NumberCountAnimatedState extends State<NumberCountAnimated>
    with SingleTickerProviderStateMixin {
  double oldValue = 0;
  late double targetValue;
  Operation operation = Operation.idle;
  late AnimationController animationController;
  final int animationDuration = 100;
  late Animation<double> tween;
  TextStyle? textStyle;
  BoxDecoration? boxDecoration;
  late EdgeInsets decorationPaddgin;

  @override
  void initState() {
    super.initState();
    textStyle = widget.textStyle;
    boxDecoration = widget.boxDecoration;
    decorationPaddgin = widget.decorationPaddgin ??
        ((boxDecoration == null) ? EdgeInsets.zero : const EdgeInsets.all(2));
    targetValue = widget.value;
    checkOperation();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: animationDuration * targetValue.toString().length,
      ),
    );
    tween = animationController.drive(
      Tween<double>(
        begin: oldValue,
        end: targetValue,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant NumberCountAnimated oldWidget) {
    if (oldWidget.value != widget.value) {
      oldValue = targetValue;
      targetValue = widget.value;
      checkOperation();
    }
    textStyle = widget.textStyle;
    boxDecoration = widget.boxDecoration;
    super.didUpdateWidget(oldWidget);
  }

  checkOperation() {
    if (oldValue < targetValue) {
      operation = Operation.increasing;
      animate();
    } else if (oldValue > targetValue) {
      operation = Operation.decreasing;
      animate();
    } else {
      operation = Operation.idle;
    }
  }

  animate() {
    animationController.value = 0;
    animationController.duration = Duration(
      milliseconds: animationDuration * targetValue.toString().length,
    );
    tween = animationController.drive(
      Tween<double>(
        begin: oldValue,
        end: targetValue,
      ),
    );
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tween,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: tween.value.toStringAsFixed(2).codeUnits.map(
            (e) {
              if (e == 46) {
                return Container(
                  padding: decorationPaddgin,
                  decoration: boxDecoration,
                  margin: decorationPaddgin,
                  child: Text(
                    String.fromCharCode(e),
                    style: textStyle,
                    textAlign: TextAlign.end,
                  ),
                );
              } else {
                return CharRoulete(
                  charCode: e,
                  operation: operation,
                  boxDecoration: boxDecoration,
                  textStyle: textStyle,
                );
              }
            },
          ).toList(),
        );
      },
    );
  }
}

enum Operation {
  increasing,
  decreasing,
  idle;
}

class CharRoulete extends StatefulWidget {
  const CharRoulete({
    super.key,
    required this.charCode,
    required this.operation,
    this.boxDecoration,
    this.textStyle,
    this.decorationPaddgin,
  });

  final int charCode;
  final Operation operation;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final EdgeInsets? decorationPaddgin;

  @override
  State<CharRoulete> createState() => _CharRouleteState();
}

class _CharRouleteState extends State<CharRoulete>
    with SingleTickerProviderStateMixin {
  late int oldCharCode;
  late int charCode;
  late Operation operation;
  late AnimationController animationController;
  TextStyle? textStyle;
  BoxDecoration? boxDecoration;
  late EdgeInsets decorationPaddgin;

  @override
  void initState() {
    super.initState();
    textStyle = widget.textStyle;
    boxDecoration = widget.boxDecoration;
    decorationPaddgin = widget.decorationPaddgin ??
        ((boxDecoration == null) ? EdgeInsets.zero : const EdgeInsets.all(2));
    oldCharCode = widget.charCode;
    charCode = widget.charCode;
    operation = widget.operation;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    animate();
  }

  @override
  void didUpdateWidget(covariant CharRoulete oldWidget) {
    if (charCode != widget.charCode) {
      oldCharCode = charCode;
      charCode = widget.charCode;
      operation = widget.operation;
      animate();
    }
    textStyle = widget.textStyle;
    boxDecoration = widget.boxDecoration;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  animate() {
    animationController.value = 0;
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final style =
        textStyle ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    final height = style.fontSize ?? 16;
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Opacity(
              opacity: 1 - animationController.value,
              child: Transform.translate(
                offset: Offset(0, (-animationController.value) * height) *
                    (operation == Operation.decreasing ? -1 : 1),
                child: Container(
                  padding: decorationPaddgin,
                  decoration: boxDecoration,
                  margin: decorationPaddgin,
                  child: Text(
                    String.fromCharCode(
                      oldCharCode,
                    ),
                    textAlign: TextAlign.end,
                    style: style,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: animationController.value,
              child: Transform.translate(
                offset: Offset(0, (animationController.value - 1) * height) *
                    (operation == Operation.decreasing ? 1 : -1),
                child: Container(
                  padding: decorationPaddgin,
                  decoration: boxDecoration,
                  margin: decorationPaddgin,
                  child: Text(
                    String.fromCharCode(
                      charCode,
                    ),
                    textAlign: TextAlign.end,
                    style: style,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
