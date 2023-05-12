import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:visionfund/src/screens/auth/login_screen.dart';
import 'package:visionfund/src/screens/auth/registration_screen.dart';
import 'package:visionfund/src/theme/theme.dart';
import 'src/screens/loading/loading_screen.dart';
import 'src/state/app_state.dart';

final _sharePref = CommonSharedPref();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  String isActivated = await _sharePref.getAppIsActivated() ?? "false";

  runApp(ChangeNotifierProvider(
      create: (context) => AppState(),
      child: EasyLocalization(
          supportedLocales: const [Locale('en')],
          path:
              'assets/translations', // <-- change the path of the translation files
          fallbackLocale: const Locale('en'),
          child: DynamicCraftWrapper(
            localizationIsEnabled: true,
            dashboard: RegistrationScreen(
              isActivated: isActivated == "true",
            ),
            appLoadingScreen: LoadingScreen(),
            appTimeoutScreen: const LoginScreen(),
            appInactivityScreen: const LoginScreen(),
            appTheme: AppTheme().appTheme,
            menuProperties: MenuProperties(
                borderColor: Colors.grey[400],
                hasBorder: true,
                borderWidth: 1.5,
                itemPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly),
            menuScreenProperties: MenuScreenProperties(
                gridcount: 3,
                childAspectRatio: 0.9,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2),
          ))));
}
