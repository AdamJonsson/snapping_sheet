import 'package:flutter/material.dart';
import 'dummy_material.dart';

class DummyBackgroundContent extends StatelessWidget {
  final accent = Color(0xff8ba38d);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[400],
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: IntrinsicHeight(
                        child: SquareMaterial(),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextMaterial(width: 54),
                          SquareMaterial(
                            color: accent,
                          ),
                          TextMaterial(width: 104),
                          SquareMaterial(),
                          TextMaterial(width: 64),
                          SquareMaterial(
                            color: accent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SquareMaterial(height: 200),
              TextMaterial(width: double.infinity),
              TextMaterial(width: 140.0),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(flex: 1, child: SquareMaterial(height: 200)),
                  Expanded(
                      flex: 1,
                      child: SquareMaterial(
                        height: 200,
                        color: accent,
                      )),
                  Expanded(flex: 1, child: SquareMaterial(height: 200)),
                  Expanded(flex: 3, child: SquareMaterial(height: 200)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
