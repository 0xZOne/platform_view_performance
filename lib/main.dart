import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Platform view Example"),
        ),
        body: Container(
          color: Colors.green[600],
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Transform.rotate(
                // rotated it with 45˚ (π/4)
                angle: math.pi / 4,
                child: Transform.scale(
                  scale: 0.85,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: SizedBox(
                      height: 300,
                      child: Opacity(
                        opacity: 1.0,
                        child: WebView(initialUrl: 'https://flutter.dev'),
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.75,
                child: Container(
                  constraints: BoxConstraints.expand(
                    height:
                        Theme.of(context).textTheme.headline4!.fontSize! * 1.1 +
                            50.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.blue[600],
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(0.2),
                  child: Text('Flutter UI',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NativeView extends StatefulWidget {
  const NativeView({Key? key}) : super(key: key);

  @override
  State<NativeView> createState() => _NativeViewState();
}

class _NativeViewState extends State<NativeView> {
  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = '<simple-text-view>';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }
}
