import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guess_numbers/controllers/home_screen_controller.dart';
import 'package:guess_numbers/models/balloon_model.dart';

import '../widgets/balloon_animated_widget.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/bg.jpg',
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const SizedBox(
                width: double.infinity,
              ),
              Obx(
                () => AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: controller.noOpacity.value,
                  onEnd: controller.animateNo,
                  child: Text(
                    textAlign: TextAlign.center,
                    controller.currentNo,
                    style: TextStyle(
                      color: const Color(0xFF0C487A),
                      fontSize: 65.sp,
                    ),
                  ),
                ),
              ),
              Obx(
                () => ConfettiWidget(
                  confettiController: controller.resultConfettiCont,
                  colors: const [
                    Color(0xFFEE8C37),
                    Color(0xFF753CF5),
                    Color(0xFF000000),
                    Color(0xFF000000),
                    Color(0xFF67D9C1),
                  ],
                  maxBlastForce: 2,
                  minBlastForce: 1,
                  numberOfParticles: 150,
                  emissionFrequency: 0.005,
                  blastDirectionality: BlastDirectionality.explosive,
                  child: Text(
                    textAlign: TextAlign.center,
                    controller.gameResult.value,
                    style: TextStyle(
                      color: const Color(0xFF0C487A),
                      fontSize: 52.sp,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 250,
              ),
              const Spacer(),
              Obx(
                () => Visibility(
                  visible: controller.showPlayButton.value,
                  child: GestureDetector(
                    onTap: () {
                      print('00000 >>><<< ;;;;; onplaypress');
                      controller.onPlayPressed();
                    },
                    child: Container(
                      decoration: BoxDecoration(color: const Color(0xFF54AAF3), borderRadius: BorderRadius.circular(55.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/play.png',
                            width: 40.w,
                            height: 40.h,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            controller.playBTNText,
                            style: TextStyle(color: Colors.white, fontSize: 15.sp),
                          ),
                          SizedBox(
                            width: 20.w,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
        Obx(
          () => Visibility(
            visible: controller.showBalloons.value,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  for (Rx<BalloonModel> balloonModel in controller.balloons)
                    SlideWidget(
                      bottom: -200,
                      left: MediaQuery.of(context).size.width * Random().nextDouble() - 160,
                      onTap: controller.onBalloonTap,
                      balloonModel: balloonModel,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
