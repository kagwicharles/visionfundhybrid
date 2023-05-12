import 'package:blur/blur.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AccountCard extends StatefulWidget {
  BankAccount? account;

  AccountCard({super.key, required this.account});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  final _accountRepository = ProfileRepository();

  bool _balanceVisible = false;
  bool _isLoading = false;
  String _balance = "";
  String _aliasName = "";

  @override
  void initState() {
    super.initState();
    _aliasName = widget.account?.aliasName ?? "A";
  }

  @override
  Widget build(BuildContext context) => Container(
        height: 177,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                APIService.appSecondaryColor,
                APIService.appPrimaryColor,
              ],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 28,
                    ),
                    const Text(
                      "home.cardtitle",
                      style: TextStyle(color: Colors.white),
                    ).tr(),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        _balanceVisible
                            ? Flexible(
                                child: Text(
                                formatNumberWithThousandsSeparator(_balance),
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff81BE41)),
                              ))
                            : const Blur(
                                blur: 3,
                                blurColor: Colors.grey,
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      "XXXXXXX",
                                      style: TextStyle(fontSize: 24),
                                    ))),
                        _isLoading
                            ? const SizedBox()
                            : IconButton(
                                iconSize: 32,
                                onPressed: () {
                                  _checkBalance(
                                      widget.account?.bankAccountId ?? "");
                                },
                                icon: Icon(
                                  _balanceVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ))
                      ],
                    ),
                    const Spacer(),
                    Text(
                      widget.account?.bankAccountId ?? "***",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 20, letterSpacing: 4),
                    )
                  ],
                )),
            Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white,
                  child: Text(
                    _aliasName.isNotEmpty ? _aliasName[0] : "A",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                )),
            _isLoading
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
      );

  String formatNumberWithThousandsSeparator(String numberString) {
    // Use RegExp to match digits and add a thousands separator
    String formattedNumber = numberString.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match.group(1)},',
    );
    return formattedNumber;
  }

  _checkBalance(String bankAccountID) async {
    _balance = "";
    setState(() {
      _balanceVisible = !_balanceVisible;
    });

    if (_balanceVisible) {
      _isLoading = true;
      _balance =
          await _accountRepository.checkAccountBalance(bankAccountID) ?? "";
      setState(() {
        _isLoading = false;
      });
    }
  }
}
