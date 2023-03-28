// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:introduction_screen/introduction_screen.dart';

// Project imports:
import 'package:restaurant_app/app/app.router.dart';
import 'package:restaurant_app/core/managers/singleton_services_injections.dart';
import 'package:restaurant_app/ui/shared/app_colors.dart';
import 'package:restaurant_app/ui/shared/ui_helpers.dart';
import 'package:restaurant_app/ui/widgets/uielements/primary_button.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd() {
    navigationService.replaceWith(Routes.loginView);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/onboarding/$assetName.png',
          width: screenWidth(context)),
      // child: Lottie.asset('assets/animations/$assetName.json'),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 19.0,
    );
    const titleStyle = TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700);
    const pageDecoration = const PageDecoration(
      titleTextStyle: titleStyle,
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Bienvenue sur Eat 224 !",
          body:
              "Nous sommes heureux de vous compter parmi nous! Pour commencer, découvrons ensemble ce qu'est Eat 224",
          image: _buildImage('3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Learn as you go",
          body:
              "Download the Stockpile app and master the market with our mini-lesson.",
          image: _buildImage('1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Another title page",
          body: "Another beautiful body text for this example onboarding",
          image: _buildImage('2'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: PrimaryButton(
        color: primaryColor,
        textColor: Colors.white,
        onPress: () {
          _onIntroEnd();
        },
        title: 'Passer',
      ),
      next: const Icon(Icons.arrow_forward),
      done: PrimaryButton(
        color: primaryColor,
        textColor: Colors.white,
        onPress: () {
          _onIntroEnd();
        },
        title: 'Débuter',
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeColor: primaryColor,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
