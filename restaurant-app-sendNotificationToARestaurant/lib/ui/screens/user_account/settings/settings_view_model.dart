// Package imports:
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:package_info/package_info.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

enum AppearenceModes { light, dark, system }

@injectable
class SettingsViewModel extends BaseViewModel {
  bool _notificationEnabled = false;
  bool get notificationEnabled => _notificationEnabled;

  Map<String, dynamic>? _aboutSettings;
  Map<String, dynamic>? get aboutSettings => _aboutSettings;

  AppearenceModes _appearenceMode = AppearenceModes.system;
  AppearenceModes get appearenceMode => _appearenceMode;

  String? appName;
  String? packageName;
  String? version;
  String? buildNumber;

  Future fetchUserLocalSettings() async {
    print('fetchUserLocalSettings');
    setBusy(true);

    setBusy(false);
  }

  Future changeNotificationState(bool value) async {
    print('changeNotificationState');
    setBusy(true);
    _notificationEnabled = value;
    setBusy(false);
  }

  Future getAboutSettings() async {
    print('getAboutSettings');
    setBusy(true);
    _aboutSettings = await generalService.getAboutSettings();
    packageInfo();
    setBusy(false);
  }

  void launchInstagram() async {
    print(aboutSettings);
    String instagramUrl = aboutSettings!['instagramLink'];

    try {
      bool launched = await launchUrl(
        Uri.parse(instagramUrl),
      );

      if (!launched) {
        await launchUrl(
          aboutSettings!['instagramLink'],
        );
      }
    } catch (e) {
      await launchUrl(
        Uri.parse(aboutSettings!['instagramLinkFallback']),
      );
    }
  }

  void launchFacebookPage() async {
    String fbProtocolUrl;
    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/${aboutSettings!['facebookLink']}';
    } else {
      fbProtocolUrl = 'fb://page/${aboutSettings!['facebookLink']}';
    }

    String fallbackUrl = aboutSettings!['facebookLinkFallback'];

    try {
      bool launched = await launchUrl(Uri.parse(fbProtocolUrl));

      if (!launched) {
        await launchUrl(Uri.parse(fallbackUrl));
      }
    } catch (e) {
      await launchUrl(Uri.parse(fallbackUrl));
    }
  }

  void appReview() {}

  Future packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    print('packageInfo.appName');

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }

  @override
  void dispose() {
    print('view model Dashboard disposed');
    super.dispose();
  }
}
