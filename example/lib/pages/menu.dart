import 'package:example/pages/horizontal_example.dart';
import 'package:example/pages/placeholder_example.dart';
import 'package:example/pages/preview_page.dart';
import 'package:example/pages/preview_reverse_page.dart';
import 'package:example/shared/appbar.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DarkAppBar(title: "Other Examples").build(context),
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
                    MenuButton(
                      page: HorizontalExample(),
                      text: "Horizontal Example",
                      color: Colors.green[300],
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
