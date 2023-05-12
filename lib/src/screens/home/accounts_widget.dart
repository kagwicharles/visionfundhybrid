import 'package:carousel_slider/carousel_slider.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionfund/src/screens/home/account_card.dart';

import '../../state/app_state.dart';

class AccountsWidget extends StatefulWidget {
  final List<BankAccount> bankAccounts;
  AccountsWidget({Key? key, required this.bankAccounts})
      : super(
          key: key,
        );

  @override
  State<AccountsWidget> createState() => _AccountsWidgetState();
}

class _AccountsWidgetState extends State<AccountsWidget> {
  final CarouselController _controller = CarouselController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<BankAccount> bankAccounts = widget.bankAccounts;
    return SizedBox(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(children: [
                SizedBox(
                    height: 177,
                    width: double.infinity,
                    child: CarouselSlider.builder(
                        options: CarouselOptions(
                            height: 400,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            reverse: false,
                            autoPlay: false,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.1,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: onSwipe),
                        itemCount: bankAccounts.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          var account = bankAccounts[itemIndex];
                          return AccountCard(account: account);
                        })),
                bankAccounts.length > 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: bankAccounts.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : APIService.appPrimaryColor)
                                      .withOpacity(_currentIndex == entry.key
                                          ? 0.9
                                          : 0.4)),
                            ),
                          );
                        }).toList(),
                      )
                    : const SizedBox(height: 12,),
              ])
            ]));
  }

  onSwipe(int index, CarouselPageChangedReason? reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  updateLoadState(bool status) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("Load status set to $status");
      Provider.of<AppState>(context, listen: false).setLoadingAccounts(status);
    });
  }
}
