import 'package:flutter/material.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/ui/screens/user_account/wallet/wallet_account_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/dashboard_item.dart';
import 'package:restaurant_app/ui/widgets/uielements/small_logo.dart';
import 'package:stacked/stacked.dart';

class WalletAccountView extends StatelessWidget {
  const WalletAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WalletAccountViewModel>.reactive(
        viewModelBuilder: () => locator<WalletAccountViewModel>(),
        disposeViewModel: false,
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Mon Compte Wallet"),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpaceMedium,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: SizedLogo(
                        width: 100,
                      ),
                    ),
                    verticalSpaceMedium,
                    Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),
                                Text(
                                  "SOLDE COURANT",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  formatCurrency(
                                      model.walletAccount?.balance ?? 0),
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    DashboardItem(
                      onTap: model.gotoRechargeAccountView,
                      icon: Icons.account_balance_wallet_outlined,
                      text: "Recharger mon compte",
                    ),
                    verticalSpaceMedium,
                    DashboardItem(
                      onTap: model.gotoUserTransactionHistoryView,
                      icon: Icons.money_off_outlined,
                      text: "Historique transactions",
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
