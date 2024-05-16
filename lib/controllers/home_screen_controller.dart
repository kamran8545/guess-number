import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guess_numbers/models/balloon_model.dart';

class HomeScreenController extends GetxController {
  String currentNo = '', playBTNText = 'Play';
  int currentNoIndex = 0, currentResultIndex = 0;

  RxList<int> generatedNumbers = <int>[].obs;

  Rx<double> noOpacity = 0.0.obs;
  RxBool showBalloons = false.obs, showPlayButton = true.obs;
  bool isWiningGame = false;

  RxString gameResult = ''.obs;
  ConfettiController resultConfettiCont = ConfettiController();

  List<Rx<BalloonModel>> balloons = <Rx<BalloonModel>>[];

  @override
  void onInit() {
    populateBalloons();
    super.onInit();
  }

  void onPlayPressed() {
    showPlayButton.value = false;
    if (playBTNText == 'Play Again') {
      gameResult.value = '';
      currentNoIndex = 0;
      currentResultIndex = 0;
      populateBalloons();
    }
    generateNo(count: 5);
    animateNo();
  }

  void animateNo() {
    if (currentNoIndex >= generatedNumbers.length) {
      showBalloons.value = true;
      noOpacity.value = 0;
      return;
    }
    if (noOpacity.value == 0) {
      currentNo = generatedNumbers[currentNoIndex++].toString();
      noOpacity.value = 1;
    } else {
      noOpacity.value = 0;
    }
  }

  void generateNo({required int count}) {
    generatedNumbers.clear();
    for (int index = 0; index < count; index++) {
      generatedNumbers.add(Random().nextInt(1000));
    }
    List<int> temp = [];
    for (Rx<BalloonModel> balloonModel in balloons) {
      var randomIndex = Random().nextInt(count);
      while (temp.contains(randomIndex)) {
        randomIndex = Random().nextInt(count);
      }
      temp.add(randomIndex);
      balloonModel.value.balloonNo = generatedNumbers[randomIndex].toString();
    }
  }

  dynamic onBalloonTap({required Rx<BalloonModel> balloonModel}) {
    if (int.parse(balloonModel.value.balloonNo) == generatedNumbers[currentResultIndex++]) {
      isWiningGame = true;
      popBalloon(balloonModel: balloonModel);
    } else {
      currentResultIndex = 5;
      isWiningGame = false;
    }
    if (currentResultIndex >= generatedNumbers.length) {
      showResult();
      return;
    }
  }

  void popBalloon({required Rx<BalloonModel> balloonModel}) {
    balloonModel.value.isPopped = true;
    balloonModel.value.balloonConfettiController.play();
    balloonModel.value.isVisible = false;
    balloonModel.refresh();
    Future.delayed(const Duration(milliseconds: 300)).then((value) => balloonModel.value.balloonConfettiController.stop());
    final assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
      volume: 100,
      Audio("assets/audio/balloon_pop.mp3"),
    );
  }

  void showResult() async {
    if (isWiningGame) {
      gameResult.value = 'You Won';
      resultConfettiCont.play();
      Future.delayed(const Duration(milliseconds: 1200)).then((value) => resultConfettiCont.stop());
      final assetsAudioPlayer = AssetsAudioPlayer();
      assetsAudioPlayer.open(
        volume: 100,
        Audio("assets/audio/balloon_pop.mp3"),
      );
    } else {
      for (var balloonModel in balloons) {
        if (!balloonModel.value.isPopped) {
          await Future.delayed(const Duration(milliseconds: 100));
          popBalloon(balloonModel: balloonModel);
        }
      }
      await Future.delayed(const Duration(seconds: 2));
      gameResult.value = 'You loose, try again';
    }
    showBalloons.value = false;
    playBTNText = 'Play Again';
    showPlayButton.value = true;
  }

  void populateBalloons() {
    balloons = <Rx<BalloonModel>>[
      BalloonModel(
        balloonIcon: 'balloon0.png',
        balloonNo: '0',
        balloonColors: const Color(0xFFEE8C37),
        balloonDelay: 0,
        balloonConfettiController: ConfettiController(),
      ).obs,
      BalloonModel(
        balloonIcon: 'balloon1.png',
        balloonNo: '0',
        balloonColors: const Color(0xFF753CF5),
        balloonDelay: 300,
        balloonConfettiController: ConfettiController(),
      ).obs,
      BalloonModel(
        balloonIcon: 'balloon2.png',
        balloonNo: '0',
        balloonColors: const Color(0xFF000000),
        balloonDelay: 600,
        balloonConfettiController: ConfettiController(),
      ).obs,
      BalloonModel(
        balloonIcon: 'balloon3.png',
        balloonNo: '0',
        balloonColors: const Color(0xFF000000),
        balloonDelay: 900,
        balloonConfettiController: ConfettiController(),
      ).obs,
      BalloonModel(
        balloonIcon: 'balloon4.png',
        balloonNo: '0',
        balloonColors: const Color(0xFF67D9C1),
        balloonDelay: 1200,
        balloonConfettiController: ConfettiController(),
      ).obs,
    ];
  }
}
