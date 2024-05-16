import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../bindings/home_screen_bindings.dart';
import '../views/screens/home_screen.dart';


class RouteNames {
  static const String kHomeScreenRoute = '/HOME_SCREEN_ROUTE';
}


class RouteManagement {

  static List<GetPage> getRoutes(){
    return [
      GetPage(
        name: RouteNames.kHomeScreenRoute,
        page: () => const HomeScreen(),
        binding: HomeScreenBindings(),
        curve: Curves.easeInOut,
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 400),
      ),
    ];
  }
}