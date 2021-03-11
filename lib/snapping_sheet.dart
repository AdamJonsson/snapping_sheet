library snapping_sheet;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _SliverBackground extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  _SliverBackground(this.child, this.maxHeight, this.minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => maxHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent;
  }
}

Widget build(BuildContext context) {
  final List<String> _tabs = ['Tab 1', 'Tab 2'];
  return DefaultTabController(
    length: _tabs.length, // This is the number of tabs.
    child: Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              // This widget takes the overlapping behavior of the SliverAppBar,
              // and redirects it to the SliverOverlapInjector below. If it is
              // missing, then it is possible for the nested "inner" scroll view
              // below to end up under the SliverAppBar even when the inner
              // scroll view thinks it has not been scrolled.
              // This is not necessary if the "headerSliverBuilder" only builds
              // widgets that do not overlap the next sliver.
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: const Text('Books'), // This is the title in the app bar.
                pinned: true,
                expandedHeight: 150.0,
                // The "forceElevated" property causes the SliverAppBar to show
                // a shadow. The "innerBoxIsScrolled" parameter is true when the
                // inner scroll view is scrolled beyond its "zero" point, i.e.
                // when it appears to be scrolled below the SliverAppBar.
                // Without this, there are cases where the shadow would appear
                // or not appear inappropriately, because the SliverAppBar is
                // not actually aware of the precise position of the inner
                // scroll views.
                forceElevated: innerBoxIsScrolled,
                bottom: TabBar(
                  // These are the widgets to put in each tab in the tab bar.
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          // These are the contents of the tab views, below the tabs.
          children: _tabs.map((String name) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                // This Builder is needed to provide a BuildContext that is
                // "inside" the NestedScrollView, so that
                // sliverOverlapAbsorberHandleFor() can find the
                // NestedScrollView.
                builder: (BuildContext context) {
                  return CustomScrollView(
                    // The "controller" and "primary" members should be left
                    // unset, so that the NestedScrollView can control this
                    // inner scroll view.
                    // If the "controller" property is set, then this scroll
                    // view will not be associated with the NestedScrollView.
                    // The PageStorageKey should be unique to this ScrollView;
                    // it allows the list to remember its scroll position when
                    // the tab view is not on the screen.
                    key: PageStorageKey<String>(name),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        // This is the flip side of the SliverOverlapAbsorber
                        // above.
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        // In this example, the inner scroll view has
                        // fixed-height list items, hence the use of
                        // SliverFixedExtentList. However, one could use any
                        // sliver widget here, e.g. SliverList or SliverGrid.
                        sliver: SliverFixedExtentList(
                          // The items in this example are fixed to 48 pixels
                          // high. This matches the Material Design spec for
                          // ListTile widgets.
                          itemExtent: 48.0,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              // This builder is called for each child.
                              // In this example, we just number each list item.
                              return ListTile(
                                title: Text('Item $index'),
                              );
                            },
                            // The childCount of the SliverChildBuilderDelegate
                            // specifies how many children this inner list
                            // has. In this example, each tab has a list of
                            // exactly 30 items, but this is arbitrary.
                            childCount: 30,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

class SnappingSheet extends StatefulWidget {
  final double grabbingHeight;
  final Widget grabbingChild;
  final Widget child;
  final Widget background;
  final ScrollController _controller;
  SnappingSheet({
    Key? key,
    required this.child,
    required this.grabbingHeight,
    required this.grabbingChild,
    required this.background,
  })   : _controller = ScrollController(),
        super(key: key);

  @override
  _SnappingSheetState createState() => _SnappingSheetState();
}

class _SnappingSheetState extends State<SnappingSheet> {
  bool _scrollingEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: LayoutBuilder(builder: (context, constraints) {
        return Listener(
          onPointerDown: (pointerData) {
            setState(() {
              _scrollingEnabled = pointerData.position.dy >
                  constraints.maxHeight -
                      widget.grabbingHeight -
                      widget._controller.offset;
            });
          },
          onPointerUp: (pointerData) {
            if (_scrollingEnabled) {
              widget._controller.animateTo(0,
                  duration: Duration(seconds: 1), curve: Curves.bounceOut);
            }
            setState(() {
              _scrollingEnabled = true;
            });
          },
          child: CustomScrollView(
            physics: _scrollingEnabled ? null : NeverScrollableScrollPhysics(),
            controller: widget._controller,
            primary: false,
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverBackground(
                  Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: this.widget.background,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: widget.grabbingHeight,
                          child: widget.grabbingChild,
                        ),
                      ),
                    ],
                  ),
                  constraints.maxHeight,
                  0,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    this.widget.child,
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
