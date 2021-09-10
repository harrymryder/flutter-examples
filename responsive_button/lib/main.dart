import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Button Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Responsive Button Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: ResponsiveButton(
            text: 'Press me',
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class ResponsiveButton extends StatefulWidget {
  const ResponsiveButton({
    Key? key,
    this.text = 'Press me',
    this.color = const Color(0xFFFFE306),
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  _ResponsiveButtonState createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  final snackBar = const SnackBar(content: Text('Button pressed!'));

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  void _tapDown(TapDownDetails details) {
    // Depress button as user presses down
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    // Elevate button as user releases finger
    _controller.reverse();

    // Vibration when user has finished interacting with button
    HapticFeedback.heavyImpact();

    // If passing a function to button
    // add widget.onPressed here

    // Show top snackbar
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text('Button pressed!'),
        leading: const Icon(Icons.info),
        backgroundColor: Colors.yellow,
        actions: [
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: widget.color,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2.0), //(x,y)
                blurRadius: 2.0,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
