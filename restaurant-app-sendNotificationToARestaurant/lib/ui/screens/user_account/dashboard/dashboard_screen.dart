// Flutter imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

// Package imports:
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/screens/user_account/dashboard/dashboard_profile_skeleton.dart';
import 'package:restaurant_app/ui/screens/user_account/dashboard/dashboard_view_model.dart';
import 'package:restaurant_app/ui/screens/user_account/user_profile/user_stream_view_model.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/dashboard_item.dart';
import 'package:restaurant_app/ui/widgets/uielements/full_flat_button.dart';
import 'package:restaurant_app/ui/widgets/uielements/separator_section.dart';
import 'package:restaurant_app/ui/widgets/uielements/small_logo.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
        viewModelBuilder: () => locator<DashboardViewModel>(),
        disposeViewModel: false,
        builder: (context, model, child) => SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalSpaceMedium,
                    UserProfileInfos(),
                    horizontalSpaceSmall,
                    Divider(),
                    if (!model.isUserLoggedOut)
                      SeparatorSection(title: 'Utilisateur'),
                    DashboardItem(
                      private: model.isUserLoggedOut,
                      onTap: () {
                        navigationService.navigateTo(Routes.userPicturesScreen);
                      },
                      text: 'Photos',
                      icon: Icons.camera_alt_outlined,
                    ),
                    DashboardItem(
                      private: model.isUserLoggedOut,
                      onTap: () {
                        navigationService
                            .navigateTo(Routes.restaurantsCollectionsScreen);
                      },
                      text: 'Mes collections',
                      icon: Icons.bookmark_outline,
                    ),
                    DashboardItem(
                      private: model.isUserLoggedOut,
                      onTap: () {
                        navigationService.navigateTo(Routes.profileView);
                      },
                      text: 'Profile',
                      icon: Icons.account_circle_outlined,
                    ),
                    DashboardItem(
                      private: model.isUserLoggedOut,
                      onTap: model.gotoWalletAccountView,
                      icon: Icons.account_balance_wallet_outlined,
                      text: "Wallet",
                    ),
                    Divider(),
                    SeparatorSection(title: 'Commandes'),
                    DashboardItem(
                      onTap: () async {
                        if (authenticationService.currentUser == null) {
                          await navigationService.navigateTo(Routes.loginView);
                          if (firebaseAuth.currentUser == null) return;
                        }
                        navigationService.navigateTo(Routes.ordersScreen);
                      },
                      text: 'Commandes',
                      icon: Icons.receipt_long_outlined,
                    ),
                    Divider(),
                    SeparatorSection(title: 'Option application'),
                    DashboardItem(
                      onTap: () {
                        navigationService
                            .navigateTo(Routes.notificationListScreen);
                      },
                      text: 'Notifications',
                      icon: Icons.notifications_outlined,
                    ),
                    DashboardItem(
                      onTap: () {
                        navigationService.navigateTo(Routes.settingsScreen);
                      },
                      text: 'Paramètres',
                      icon: Icons.settings_outlined,
                    ),
                    DashboardItem(
                      onTap: () {
                        Share.share(
                            'Téléchargez l\'application MadiFood sur Google Play Store: https://play.google.com/store/apps/details?id=com.restaurant_app.restaurant_app');
                      },
                      text: 'Partager l\'application',
                      icon: Icons.mobile_screen_share_outlined,
                    ),
                    verticalSpaceMedium,
                    if (model.currentUser != null)
                      FullFlatButton(
                        title: 'Se déconnecter',
                        color: Colors.grey[300]!,
                        textColor: Colors.black,
                        onPress: () => model.logOut(),
                      ),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ));
  }
}

class UserProfileInfos extends ViewModelWidget<DashboardViewModel> {
  UserProfileInfos({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, DashboardViewModel model) {
    return model.currentUser == null
        ? LogedOutProfile()
        : ViewModelBuilder<UserStreamViewModel>.reactive(
            viewModelBuilder: () => locator<UserStreamViewModel>(),
            disposeViewModel: false,
            builder: (context, model, child) =>
                !model.dataReady ? DashBoardProfileSkeleton() : UserProfile(),
          );
  }
}

class LogedOutProfile extends ViewModelWidget<DashboardViewModel> {
  const LogedOutProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, DashboardViewModel model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedLogo(
            width: 100,
          ),
          verticalSpaceSmall,
          Text(
            'Connectez-vous ou inscrivez-vous pour voir votre profil complet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          verticalSpaceSmall,
          FullFlatButton(
            title: 'Continuer',
            width: screenWidth(context),
            onPress: () {
              model.navigateToLogin();
            },
          )
        ],
      ),
    );
  }
}

class UserProfile extends ViewModelWidget<UserStreamViewModel> {
  UserProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, UserStreamViewModel model) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(model.user?.userProfileUrl ?? ''),
              backgroundColor: Colors.grey[100],
              radius: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${model.user?.firstname} ${model.user?.lastname}',
              maxLines: 2,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 0),
            child: Text(
              '(${model.user?.email})',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
