import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

void main() {
  runApp(SnappingSheetExample());
}

class SnappingSheetExample extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Menu(),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SnappingSheet(
          background: Container(
            color: Colors.pink[200],
            child: Center(
              child: SizedBox(
                height: 300,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Placeholder(
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Placeholder(
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Placeholder(
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Placeholder(
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Placeholder(
                        color: Colors.yellow,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Placeholder(
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          grabbingHeight: 100,
          grabbingChild: Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                )),
          ),
          child: Container(
            height: 400.0,
            child: Placeholder(),
          ),
        ),
      ),
    );
  }
}
