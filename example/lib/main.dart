import 'package:example/pages/placeholder_example.dart';
import 'package:example/pages/preview_page.dart';
import 'package:flutter/material.dart';

import 'pages/preview_reverse_page.dart';

void main() {
  runApp(SnappingSheetExample());
}

class SnappingSheetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snapping Sheet Examples',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[700],
          elevation: 0,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        primarySwatch: Colors.grey,
      ),
      home: Menu(),
      // home: PreviewReversePage(),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: LayoutBuilder(builder: (context, boxConstraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: boxConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    MenuButton(
                      page: PreviewPage(),
                      text: "Preview Example",
                      color: Colors.grey[300],
                    ),
                    MenuButton(
                      page: PlaceholderExample(),
                      text: "Placeholder Example",
                      color: Colors.green[300],
                    ),
                    MenuButton(
                      page: PreviewReversePage(),
                      text: "Preview Reverse Example",
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Widget page;

  const MenuButton(
      {Key? key, this.color, required this.text, required this.page})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        color: color,
        constraints: BoxConstraints(minHeight: 200.0),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return page;
            }));
          },
          child: Center(
            child: Text(
              this.text,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
