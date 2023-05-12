import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:share_plus/share_plus.dart';

class ShareWidget extends StatelessWidget {
  const ShareWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "home.sharetitle",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ).tr(),
            const SizedBox(
              height: 8,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    color: APIService.appPrimaryColor,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(12.0))),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "home.sharemessage",
                          style: TextStyle(color: Colors.white),
                        ).tr(),
                        CircleAvatar(
                          child: IconButton(
                              onPressed: () {
                                PackageInfo.fromPlatform().then((packageInfo) {
                                  Share.share(
                                      'Get Vision Fund today:\nhttps://play.google.com/store/apps/details?id=${packageInfo.packageName}');
                                });
                              },
                              icon: const Icon(Icons.share)),
                        )
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }
}
