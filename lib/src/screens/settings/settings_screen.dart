import 'package:cached_network_image/cached_network_image.dart';
import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _moduleRepo = ModuleRepository();
  String title = "Settings";

  @override
  initState() {
    super.initState();
    getSettingsModule();
  }

  getSettingsModules() => _moduleRepo.getModulesById("MYACCOUNTS");

  getSettingsModule() async {
    var module = await _moduleRepo.getModuleById("MYACCOUNTS");
    setState(() {
      title = module?.moduleName ?? "Settings";
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 44,
                ),
                const Text(
                  "Options",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                FutureBuilder<List<ModuleItem>?>(
                    future: getSettingsModules(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ModuleItem>?> snapshot) {
                      Widget child = LoadUtil();
                      var modules = snapshot.data ?? [];

                      if (modules.isNotEmpty) {
                        child = ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: modules.length,
                          itemBuilder: (BuildContext context, index) => InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            onTap: () {
                              ModuleUtil.onItemClick(modules[index], context);
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.5,
                                        color: Colors.grey.withOpacity(.4)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(modules[index].moduleName),
                                      CachedNetworkImage(
                                          height: 44,
                                          width: 44,
                                          imageUrl:
                                              modules[index].moduleUrl ?? "")
                                    ])),
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 15,
                          ),
                        );
                      }
                      return child;
                    }),
                const SizedBox(
                  height: 44,
                ),
                OutlinedButton(
                    onPressed: () {
                      logout();
                    },
                    style: ButtonStyle(
                        iconSize: MaterialStateProperty.all(40),
                        iconColor: MaterialStateProperty.all(
                            APIService.appPrimaryColor),
                        side: MaterialStateProperty.all(
                            BorderSide(color: APIService.appPrimaryColor))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Logout")
                      ],
                    )),
                const SizedBox(
                  height: 54,
                ),
                FutureBuilder<String>(
                    future: DeviceInfo.getAppVersion(),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      Widget child = SizedBox();
                      if (snapshot.hasData) {
                        child = Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/icon/vision_logo.jpg",
                                  height: 28,
                                  width: 28,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text("Version: ${snapshot.data}"),
                              ],
                            ));
                      }
                      return child;
                    }),
              ],
            )),
      );

  logout() {
    return AlertUtil.showAlertDialog(context, "home.logoutmessage".tr(),
                isConfirm: true, confirmButtonText: "Logout", title: "Logout")
            .then((value) {
          if (value) {
            Navigator.of(context).pop();
          }
        }) ??
        false;
  }
}
