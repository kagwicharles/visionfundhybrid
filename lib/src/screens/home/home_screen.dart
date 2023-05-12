import 'package:cached_network_image/cached_network_image.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:visionfund/src/screens/home/accounts_widget.dart';
import 'package:visionfund/src/screens/home/share_widget.dart';
import 'package:visionfund/src/screens/home/transaction_history.dart';
import 'package:visionfund/src/screens/settings/settings_screen.dart';

import '../loading/home_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeRepo = HomeRepository();
  final _profileRepo = ProfileRepository();
  final _moduleRepo = ModuleRepository();
  final _sessionRepo = SessionRepository();
  final _accountRepository = ProfileRepository();

  List<BottomNavigationBarItem> tabItems = [];
  List<ModuleItem> tabMenus = [];
  List<ModuleItem> tabModules = [];
  List<ModuleItem> transactionHistoryModules = [];
  ModuleItem? transactionHist;

  String firstName = "";
  String _currentModuleID = "";
  String _currentModuleName = "";
  int _currentIndex = 0;

  Future<List<BankAccount>> loadHome() async {
    tabModules = await _moduleRepo.getModulesById(_currentModuleID) ?? [];
    transactionHistoryModules =
        await _moduleRepo.getModulesById("TRANSACTIONHISTORY") ?? [];
    transactionHist = await _moduleRepo.getModuleById("TRANSACTIONHISTORY");
    return _accountRepository.getUserBankAccounts();
  }

  addTabItems(int currentIndex) async {
    tabItems.clear();
    tabMenus = await _homeRepo.getTabModules() ?? [];
    tabMenus.toList().sort(((a, b) {
      return a.displayOrder!.compareTo(b.displayOrder!);
    }));
    setState(() {
      tabMenus.asMap().forEach((index, tab) {
        if (tabItems.length < 4) {
          tabItems.add(
            BottomNavigationBarItem(
              icon: CachedNetworkImage(
                imageUrl: currentIndex == index
                    ? tab.moduleUrl ?? ""
                    : tab.moduleUrl2 ?? "",
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
              label: tab.moduleName,
            ),
          );
        }
        if (currentIndex == 0) {
          _currentModuleID = tabMenus[0].moduleId;
          _currentModuleName = tabMenus[0].moduleName;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    addTabItems(0);
    getUserInfo();
    _sessionRepo.startSession();
  }

  getUserInfo() async {
    await _profileRepo.getUserInfo(UserAccountData.FirstName).then((value) {
      setState(() {
        firstName = value.isEmpty ? "Friend" : value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
        automaticallyImplyLeading: false,
        toolbarHeight: 77,
        backgroundColor: Colors.transparent,
        title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  CommonUtils.navigateToRoute(
                      context: context, widget: const SettingsScreen());
                },
                icon: Image.asset(
                  "assets/images/menu.png",
                  width: 40,
                  height: 40,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "home.title",
                    style: TextStyle(
                        color: APIService.appSecondaryColor, fontSize: 18),
                  ).tr(),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    firstName,
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  )
                ],
              )
            ]),
      ),
      body: WillPopScope(
          onWillPop: () {
            return AlertUtil.showAlertDialog(context, "home.logoutmessage".tr(),
                        isConfirm: true,
                        confirmButtonText: "Logout",
                        title: "Logout")
                    .then((value) {
                  if (value) {
                    Navigator.of(context).pop();
                  }
                }) ??
                false;
          },
          child: FutureBuilder<List<BankAccount>>(
              future: loadHome(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<BankAccount>> snapshot) {
                Widget child = HomeLoading();
                if (snapshot.hasData) {
                  AppLogger.appLogI(
                      tag: "bank accounts", message: snapshot.data?.length);
                  child = SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 14, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _currentIndex == 0
                              ? AccountsWidget(
                                  bankAccounts: snapshot.data ?? [],
                                )
                              : const SizedBox(),
                          _currentIndex == 0
                              ? const ShareWidget()
                              : const SizedBox(),
                          _currentIndex == 0
                              ? TransactionHistory(
                                  transactions: transactionHistoryModules,
                                  transactionHist: transactionHist,
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 22,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                tabMenus.isNotEmpty
                                    ? tabMenus[_currentIndex].moduleName
                                    : "",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          _currentModuleName.isEmpty
                              ? const SizedBox()
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  itemCount: tabModules.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 4,
                                          mainAxisSpacing: 4,
                                          childAspectRatio: 0.9),
                                  itemBuilder: (BuildContext context, index) =>
                                      ModuleItemWidget(
                                          moduleItem: tabModules[index]))
                        ],
                      ));
                }
                return child;
              })),
      bottomNavigationBar: tabItems.length >= 2
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: _currentIndex,
              items: tabItems,
              onTap: (index) {
                _currentIndex = index;
                bool isTabDisabled = tabMenus[index].isDisabled ?? false;
                if (isTabDisabled == false) {
                  _currentModuleID = tabMenus[index].moduleId;
                  _currentModuleName = tabMenus[index].moduleName;
                  addTabItems(index);
                } else {
                  CommonUtils.showToast("Coming soon");
                }
              },
            )
          : null,
    );
  }
}
