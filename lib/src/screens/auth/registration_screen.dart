import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visionfund/src/screens/auth/activation_screen.dart';
import 'package:visionfund/src/screens/auth/base_auth_screen.dart';
import 'package:visionfund/src/screens/auth/login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  final bool isActivated;

  const RegistrationScreen({super.key, required this.isActivated});

  @override
  Widget build(BuildContext context) => BaseAuthScreen(
          screen: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        children: [
          Text(
            'selfreg.title'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 28),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 1500.ms),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'selfreg.subtitle',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ).tr(),
          const SizedBox(
            height: 15,
          ),
          WidgetFactory.buildButton(context, () {
            CommonUtils.navigateToRoute(
                context: context,
                widget: isActivated
                    ? const LoginScreen()
                    : const ActivationScreen());
          }, "selfreg.button1".tr(), color: APIService.appSecondaryColor),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "or",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          OutlinedButton(
              onPressed: () {
                CommonUtils.showToast("Coming soon");
              },
              child: const Text(
                "selfreg.button2",
                style: TextStyle(color: Colors.white),
              ).tr())
        ],
      ));
}
