// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

// Project imports:
import 'package:restaurant_app/app/app.locator.dart';
import 'package:restaurant_app/ui/screens/startup/startup_viewmodel.dart';

class StartupView extends HookWidget {
  const StartupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController();
    return ViewModelBuilder<StartupViewModel>.reactive(
      onModelReady: (model) async {
        await model.launchLocationProcess();
        animationController.forward();
        SchedulerBinding.instance
            .addPostFrameCallback((_) => model.launchAuthProcess());
      },
      viewModelBuilder: () => locator<StartupViewModel>(),
      disposeViewModel: false,
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Lottie.asset(
          'assets/animations/splash.json',
          controller: animationController,
          onLoaded: (composition) {
            animationController.addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                model.indicateAnimationComplete();
              }
            });

            print('onload');

            // Configure the AnimationController with the duration of the
            // Lottie file and start the animation.
            animationController.duration = composition.duration;
          },
        )),
      ),
    );
  }
}
