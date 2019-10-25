import 'package:example/layout_example.dart';
import 'package:example/use_example.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/ListViewExample': (context) => UseSnapSheetExample(),
        '/PlaceholderExample': (context) => LayoutSnapSheetExample(),
      },
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Listview example'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/ListViewExample');
                    },
                  ),
                  RaisedButton(
                    child: Text('Placeholder example'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/PlaceholderExample');
                    },
                  ),
                ],
              ),
            );
          },
        ),
      )
    );
  }
}
