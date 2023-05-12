import 'package:cached_network_image/cached_network_image.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CacheImage extends StatelessWidget {
  final String imageUrl;

  const CacheImage({super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: imageUrl,
        errorWidget: (context, url, error) => SpinKitPulse(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven
                    ? APIService.appPrimaryColor
                    : APIService.appSecondaryColor,
              ),
            );
          },
        ),
        fit: BoxFit.fill,
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
      );
}
