import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:craft_dynamic/dynamic_widget.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  List<ModuleItem> transactions = [];
  ModuleItem? transactionHist;
  TransactionHistory(
      {super.key, required this.transactions, this.transactionHist});

  final _moduleRepo = ModuleRepository();

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 22,
        ),
        Text(
          transactionHist?.moduleName ?? "Transaction History",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9),
            itemBuilder: (BuildContext context, index) =>
                ModuleItemWidget(moduleItem: transactions[index]))
      ]));

  getTransactionHistoryModules() =>
      _moduleRepo.getModulesById("TRANSACTIONHISTORY");
}

class ModuleSkeleton extends StatelessWidget {
  final String image;
  final String title;

  const ModuleSkeleton({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: Colors.grey[400]!)),
      child: Column(
        children: [
          Image.asset(
            "assets/images/$image",
            width: 54,
            height: 54,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(title)
        ],
      ));
}
