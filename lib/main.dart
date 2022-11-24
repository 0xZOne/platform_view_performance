import 'package:flutter/material.dart';
import 'native_view.dart';
import 'texture_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const double width = 300;
    const double height = 120;
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
                        child: ListTile(
                          title: Text('Flutter View: ${index + 1}'),
                        ),
                      ),
                      const Card(
                        elevation: 2.0,
                        child: SizedBox(
                          height: 120,
                          // child: NativeView(),
                          child: TextureWidget(width: width, height: height),
                        ),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
