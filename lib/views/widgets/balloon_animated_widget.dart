import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:guess_numbers/models/balloon_model.dart';

class SlideWidget extends StatefulWidget {
  const SlideWidget({
    super.key,
    required this.balloonModel,
    required this.bottom,
    required this.left,
    required this.onTap,
  });

  final Rx<BalloonModel> balloonModel;
  final double left;
  final double bottom;
  final Function({required Rx<BalloonModel> balloonModel}) onTap;

  @override
  State<SlideWidget> createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> {
  var offset = const Offset(0, 0).obs;
  var duration = const Duration(seconds: 15);

  bool isBalloonClickable = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: widget.balloonModel.value.balloonDelay * 3));
      offset.value = const Offset(0, -10);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.bottom,
      left: widget.left > 0 ? widget.left : 180,
      child: Obx(
        () => AnimatedSlide(
          duration: duration,
          offset: offset.value,
          child: GestureDetector(
            onTap: () {
              if (isBalloonClickable) {
                isBalloonClickable = false;
                widget.onTap(balloonModel: widget.balloonModel);
              }
            },
            child: SizedBox(
              height: 140.h,
              width: 140.w,
              child: Stack(
                alignment: Alignment.bottomCenter,
                fit: StackFit.loose,
                children: [
                  SizedBox(
                    width: 180.w,
                    height: 180.h,
                    child: const Text(''),
                  ),
                  Obx(
                    () => Visibility(
                      visible: widget.balloonModel.value.isVisible,
                      child: Image.asset(
                        'assets/icons/${widget.balloonModel.value.balloonIcon}',
                        width: 180,
                        height: 180,
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: widget.balloonModel.value.isVisible,
                      child: Positioned(
                        bottom: 100,
                        child: Text(
                          widget.balloonModel.value.balloonNo,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ConfettiWidget(
                    colors: [widget.balloonModel.value.balloonColors],
                    maxBlastForce: 2,
                    minBlastForce: 1,
                    numberOfParticles: 50,
                    emissionFrequency: 0.005,
                    confettiController: widget.balloonModel.value.balloonConfettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
