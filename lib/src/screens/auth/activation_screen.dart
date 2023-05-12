import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:vibration/vibration.dart';

import 'package:visionfund/src/screens/auth/base_auth_screen.dart';
import 'package:visionfund/src/screens/auth/otp_screen.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _authRepo = AuthRepository();

  String completeNumber = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) => BaseAuthScreen(
          screen: Column(
        children: [
          const Text(
            "activate.title",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ).tr(),
          const SizedBox(
            height: 15,
          ),
          Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 22),
                children: [
                  IntlPhoneField(
                    controller: _phoneController,
                    disableLengthCheck: true,
                    decoration: InputDecoration(
                      hintText: 'activate.mobile'.tr(),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    initialCountryCode: 'ET',
                    onChanged: (phone) {
                      completeNumber = phone.completeNumber.formatPhone();
                      // _countryCode = phone.countryCode;
                    },
                    validator: (value) {
                      var phone = value?.number ?? "";

                      if (phone.length != 9) {
                        return "Invalid mobile";
                      } else if (phone == "") {
                        return "activate.mobile".tr();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  WidgetFactory.buildTextField(
                      context,
                      TextFormFieldProperties(
                        controller: _pinController,
                        isEnabled: true,
                        isObscured: true,
                        textInputType: TextInputType.number,
                        inputDecoration: InputDecoration(
                          hintText: "activate.pin".tr(),
                          errorStyle:
                              TextStyle(color: APIService.appSecondaryColor),
                        ),
                      ), (pin) {
                    if (pin != null) {
                      if (pin.isEmpty || pin.length < 4) {
                        return "Enter a valid pin";
                      }
                    }
                  }),
                  const SizedBox(
                    height: 44,
                  ),
                  _isLoading
                      ? LoadUtil(
                          colors: [Colors.white, APIService.appSecondaryColor],
                        )
                      : WidgetFactory.buildButton(
                          context, _activateApp, "activate.button1".tr(),
                          color: APIService.appSecondaryColor),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ))
        ],
      ));

  _activateApp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _authRepo
          .activate(mobileNumber: completeNumber, pin: _pinController.text)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value.status == StatusCode.success.statusCode) {
          CommonUtils.navigateToRoute(
              context: context,
              widget: OTPScreen(
                mobileNumber: completeNumber,
                pin: _pinController.text,
              ));
        } else {
          CommonUtils.showToast(value.message ?? "Unknown error");
        }
      });
    } else {
      CommonUtils.vibrate();
    }
  }
}
