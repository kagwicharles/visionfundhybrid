import 'package:blur/blur.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  bool shimmerIsDisabled;

  LoadingScreen({super.key, this.shimmerIsDisabled = false});

  @override
  Widget build(BuildContext context) => Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("assets/images/splash.png"),
                shimmerIsDisabled
                    ? Image.asset("assets/images/logo.png")
                    : Image.asset("assets/images/logo.png")
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .shimmer(duration: 2000.ms),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Powered by:",
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Image.asset("assets/images/cs_logo.png")
                      ],
                    ))
              ],
            ),
            shimmerIsDisabled
                ? SpinKitWave(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven
                              ? APIService.appPrimaryColor
                              : APIService.appSecondaryColor,
                        ),
                      );
                    },
                  ).frosted(
                    blur: 2,
                    borderRadius: BorderRadius.circular(12),
                  )
                : const SizedBox()
          ],
        ),
      ));
}
