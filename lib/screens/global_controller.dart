import 'package:get/get.dart';

import '../constants/navigation_menu.dart';

class GlobalController extends GetxController{
  NavigationMenu _menu;

  NavigationMenu get menu => _menu;

  set menu(NavigationMenu value) {
    _menu = value;
  }
}