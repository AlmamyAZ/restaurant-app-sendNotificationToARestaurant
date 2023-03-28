import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_app/core/managers/helper_functions.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/core/models/cart.dart';
import 'package:restaurant_app/core/models/order.dart';
import 'package:restaurant_app/core/models/payment.dart';

import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/dashboard_item.dart';
import 'package:restaurant_app/ui/widgets/uielements/small_logo.dart';

class OrderDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Order order = ModalRoute.of(context)!.settings.arguments as Order;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details commande',
              style: Theme.of(context).appBarTheme.toolbarTextStyle,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
              decoration: BoxDecoration(
                  color: formatOrderStatus(order.status!)!['color'],
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                '${formatOrderStatus(order.status!)!['label']}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceMedium,
              HeaderSection(order: order),
              verticalSpaceLarge,
              OrderRecapSection(order: order),
              verticalSpaceMedium,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(),
              ),
              BillSection(order: order),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(),
              ),
              DashboardItem(
                  onTap: () {},
                  hasNext: false,
                  text: 'Telecharger le PDF',
                  icon: Icons.download_outlined),
              Divider(
                height: 0,
                indent: 70,
              ),
              DashboardItem(
                onTap: () {},
                hasNext: false,
                text: 'Renvoyer l\'email',
                icon: Icons.email_outlined,
              ),
              verticalSpaceMedium
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  final order;
  const HeaderSection({Key? key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedLogo(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Cera Pro',
                            fontSize: 12,
                          ),
                          text: "Total ",
                        ),
                        TextSpan(
                          style: TextStyle(
                              fontFamily: 'Cera Pro',
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: Colors.black),
                          text: "${formatCurrency(order.total)}",
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceTiny,
                  Text(
                    '${DateFormat.yMMMMd('fr_FR').format(order.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          verticalSpaceMedium,
          Text(
              'Merci d\'avoir passé commande, ${firebaseAuth.currentUser?.displayName}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          verticalSpaceMedium,
          Text(
            'Voici votre facture pour ${order.restaurantName}',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class OrderRecapSection extends StatelessWidget {
  final Order order;
  const OrderRecapSection({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Text(
              '${formatCurrency(order.total)}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ],
        ),
        Divider(),
        ...order.products!
            .map((e) => buildListTile(e, context, order))
            .toList(),
        buildRowDetailPrice('Sous total', order.subTotal!, bold: true),
        buildRowDetailPrice('Frais de livraison', 20000),
        buildRowDetailPrice('Frais de service', 2000),
      ]),
    );
  }

  Widget buildRowDetailPrice(String title, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
              color: Colors.grey[600]),
        ),
        Text(
          formatCurrency(amount),
          style: TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
              color: Colors.grey[600]),
        ),
      ]),
    );
  }

  Widget buildListTile(
    Product e,
    BuildContext context,
    dynamic order,
  ) {
    return ListTile(
      horizontalTitleGap: 0,
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      leading: Text(
        '${e.quantity} x',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: primaryColor),
      ),
      title: Text(
        '${e.alias}',
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      trailing: Text(
        formatCurrency(e.quantity! * e.price!),
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}

class BillSection extends StatelessWidget {
  final order;
  const BillSection({Key? key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Montant facturé',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]),
          ),
          ListTile(
            dense: true,
            leading: SizedBox(
              width: 30,
              child: Image.asset(
                order.paymentMethod == PaymentMethod.orangeMoney
                    ? 'assets/images/logo_icons/OM.png'
                    : 'assets/images/logo_icons/MM.png',
              ),
            ),
            trailing: Text('${formatCurrency(order.total)}',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black)),
            minLeadingWidth: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            title: SizedBox(
              width: screenWidth(context) / 1.5,
              child: Text('627 47 16 55',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black)),
            ),
          ),
          verticalSpaceSmall,
          Text(
            "Un prélèvement temporaire de ${formatCurrency(order.total)} a été effectué sur votre compte (627 47 16 55). Ce motant vous sera facturé seulement après acceptation de votre commande par le restaurant. Dans le cas d'un rejet du restaurant ou d'une annulation de votre part avant le début de la préparation de la commande par le restaurant, le montant vous sera remboursé en totalité, cependant les frais de services ne seront pas remboursés.",
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
