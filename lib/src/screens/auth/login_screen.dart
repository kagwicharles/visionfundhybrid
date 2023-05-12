import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import 'package:visionfund/src/screens/auth/base_auth_screen.dart';
import 'package:visionfund/src/screens/home/home_screen.dart';
import 'package:visionfund/src/screens/loading/home_loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _authRepo = AuthRepository();

  String completeNumber = "";
  bool _isLoading = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    userBiometrics();
  }

  Future<bool> userBiometrics({isButtonAction = false}) async {
    setState(() {
      _isLoading = true;
    });
    var res = await _authRepo.biometricLogin(
      _pinController,
    );
    setState(() {
      _isLoading = false;
    });
    if (res) {
      _pinController.clear();
      CommonUtils.navigateToRoute(context: context, widget: const HomeScreen());
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) => BaseAuthScreen(
          screen: Column(
        children: [
          const Text(
            "login.title",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ).tr(),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
                  onTap: () async {
                    await userBiometrics(isButtonAction: true);
                  },
                  child: Image.asset("assets/images/fingerprint.png"))
              .animate()
              .fadeIn(duration: 1500.ms),
          const SizedBox(
            height: 18,
          ),
          Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                children: [
                  WidgetFactory.buildTextField(
                      context,
                      TextFormFieldProperties(
                        controller: _pinController,
                        isEnabled: true,
                        isObscured: _isObscured,
                        textInputType: TextInputType.number,
                        inputDecoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _isObscured
                                  ? Icon(
                                      Icons.visibility,
                                      color: APIService.appPrimaryColor,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: APIService.appPrimaryColor,
                                    ),
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                            ),
                            hintText: "login.pin".tr(),
                            errorStyle:
                                TextStyle(color: APIService.appSecondaryColor)),
                      ), (pin) {
                    if (pin != null) {
                      if (pin.isEmpty || pin.length < 4) {
                        return "Enter a valid pin";
                      }
                    }
                  }),
                  const SizedBox(
                    height: 28,
                  ),
                  _isLoading
                      ? LoadUtil(
                          colors: [Colors.white, APIService.appSecondaryColor],
                        )
                      : WidgetFactory.buildButton(
                          context, _login, "login.button1".tr(),
                          color: APIService.appSecondaryColor),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )),
          // const SizedBox(
          //   height: 15,
          // ),
          // TextButton(onPressed: () {}, child: const Text("Forgot Pin"))
        ],
      ));

  _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _authRepo.login(_pinController.text).then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value.status == StatusCode.success.statusCode) {
          _pinController.clear();
          CommonUtils.navigateToRoute(
              context: context, widget: const HomeScreen());
        } else {
          _pinController.clear();
          CommonUtils.showToast(
              value.message ?? "Unable to login at the moment");
        }
      });
    } else {
      CommonUtils.vibrate();
    }
  }
}
