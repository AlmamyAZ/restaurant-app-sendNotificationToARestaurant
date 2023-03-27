import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/ui/screens/user_account/wallet/transaction_history_view_model.dart';
import 'package:restaurant_app/ui/widgets/uielements/empty_list.dart';
import 'package:restaurant_app/ui/widgets/wallet/transaction_skeleton.dart';
import 'package:stacked/stacked.dart';

class UserTransactionHistoryView extends StatelessWidget {
  const UserTransactionHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserTransactionHistoryViewModel>.reactive(
        viewModelBuilder: () => locator<UserTransactionHistoryViewModel>(),
        disposeViewModel: false,
        onModelReady: (model) {
          model.getUserTransactionHistories();
        },
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Historique"),
              ),
              body: model.isBusy
                  ? WalletTransactionSkeleton()
                  : Container(
                      child: model.transactionHistory.length == 0
                          ? EmptyList(
                              sign: Icon(
                                Icons.no_meals,
                                color: Colors.grey[400],
                                size: 150,
                              ),
                              message: 'Rien à afficher pour le moment',
                            )
                          : ListView.builder(
                              itemCount: model.transactionHistory.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[100],
                                      child: !model
                                              .transactionHistory[index].isEntry
                                          ? Icon(
                                              Icons.arrow_upward,
                                              color: Colors.red,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                            )
                                          : Icon(
                                              Icons.arrow_downward,
                                              color: Colors.green,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.04,
                                            ),
                                    ),
                                    title: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "No: ${model.transactionHistory[index].transactionNumber}",
                                          ),
                                          Text(
                                              "${model.transactionHistory[index].name}"),
                                          Text(
                                            "${DateFormat.yMMMMd('fr_FR').format(model.transactionHistory[index].createdAt)}",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Container(
                                        child: Column(
                                      children: [
                                        Text(
                                          "${formatCurrency(model.transactionHistory[index].amount.toDouble())}",
                                        ),
                                      ],
                                    )),
                                  ),
                                );
                              }),
                    ));
        });
  }
}
