import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class BalloonModel {
  String balloonIcon = '';
  String balloonNo = '';
  Color balloonColors = Colors.transparent;
  int balloonDelay = 0;
  bool isPopped;
  bool isVisible;
  ConfettiController balloonConfettiController;

  BalloonModel({
    required this.balloonIcon,
    required this.balloonNo,
    required this.balloonColors,
    required this.balloonDelay,
    this.isPopped = false,
    this.isVisible = true,
    required this.balloonConfettiController,
  });
}
