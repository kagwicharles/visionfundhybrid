import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeLoading extends StatelessWidget {
  const HomeLoading({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(child: Image.asset("assets/images/logo.png")),
          SpinKitFadingCircle(
            size: 64,
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven
                      ? APIService.appPrimaryColor
                      : APIService.appSecondaryColor,
                ),
              );
            },
          )
        ]),
      ));
}
