import 'dart:async';

import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:visionfund/src/screens/auth/base_auth_screen.dart';
import 'package:visionfund/src/screens/auth/login_screen.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  String pin;

  OTPScreen({super.key, required this.mobileNumber, this.pin = ""});

  @override
  State<StatefulWidget> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _authRepo = AuthRepository();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Stopwatch _stopwatch = Stopwatch();

  bool _isLoading = false;
  String _stopwatchText = '01:00'; // initial stopwatch text
  int _timerCount = 60; // initial timer count in seconds
  late Timer _timer; // tim

  @override
  initState() {
    super.initState();
    configureTimer();
  }

  configureTimer() {
    _stopwatch = Stopwatch()..start();
    _timerCount = 60;
    // start the timer
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _stopwatchText =
            _formatTime(60 * 1000 - _stopwatch.elapsedMilliseconds);
        _timerCount--;
        if (_timerCount == 0) {
          _stopwatchText = "00:00";
        }
      });
      // check if stopwatch has reached 0
      if (_stopwatch.elapsed.inSeconds >= 60) {
        _stopwatch.stop();
        _timer.cancel();
      }
    });
  }

  String _formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).floor();
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;
    if (seconds < 0) {
      seconds += 60;
      minutes--;
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) => BaseAuthScreen(
      screen: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 22),
            children: [
              Align(
                  alignment: Alignment.center,
                  child: const Text(
                    "otp.title",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ).tr()),
              const SizedBox(
                height: 15,
              ),
              Pinput(
                length: 6,
                controller: _otpController,
                defaultPinTheme: const PinTheme(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
                forceErrorState: true,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                validator: (pin) {
                  if (pin != null) {
                    if (pin.isEmpty || pin.length < 6) {
                      return 'Otp is incorrect';
                    }
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
              _isLoading
                  ? LoadUtil(
                      colors: [Colors.white, APIService.appSecondaryColor],
                    )
                  : WidgetFactory.buildButton(
                      context, _verifyOTP, "otp.button1".tr(),
                      color: APIService.appSecondaryColor),
              const SizedBox(
                height: 28,
              ),
              Center(
                  child: InkWell(
                      onTap: _isLoading || _timerCount != 0
                          ? null
                          : () {
                              _resendOtp();
                            },
                      child: Text(
                        "otp.button2".tr(),
                        style: TextStyle(color: Colors.grey[400]),
                      ))),
              const SizedBox(
                height: 12,
              ),
              Center(
                  child: Text(
                _stopwatchText,
                style: TextStyle(color: Colors.grey[200]),
              )),
              const SizedBox(
                height: 24,
              ),
            ],
          )));

  _verifyOTP() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _authRepo
          .verifyOTP(
              mobileNumber: widget.mobileNumber, otp: _otpController.text)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value.status == StatusCode.success.statusCode) {
          CommonUtils.navigateToRouteAndPopAll(
              context: context, widget: const LoginScreen());
        } else {
          AlertUtil.showAlertDialog(context, value.message ?? "Unknown error");
        }
      });
    }
  }

  _resendOtp() {
    setState(() {
      _isLoading = true;
    });
    _authRepo
        .activate(mobileNumber: widget.mobileNumber, pin: widget.pin)
        .then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.status == StatusCode.success.statusCode) {
        _otpController.clear();
        configureTimer();
      } else {
        CommonUtils.showToast(value.message);
      }
    });
  }
}
