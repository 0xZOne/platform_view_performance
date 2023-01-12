import 'package:flutter/foundation.dart';
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Platform view Example"),
        ),
        body: ListView.builder(
            itemCount: 1000,
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 4.0, right: 10.0, bottom: 4.0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 2.0,
                        child: SizedBox(
                          height: 100,
                          child: ListTile(
                            tileColor: Colors.white,
                            title: Text('Flutter View: ${index + 1}'),
                          ),
                        ),
                      ),
                      const Card(
                        elevation: 2.0,
                        child: SizedBox(
                          height: 100,
                          child: NativeView(),
                        ),
                      ),
                    ],
                  ),
                )),
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
