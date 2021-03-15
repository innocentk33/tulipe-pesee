import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeController extends GetxController {
  RxString _login = "".obs;

  clearSession() {
    GetStorageService.clearUserLogin();
  }

  getLogin() async {
    _login.value = await GetStorageService.getLogin();
  }

  String get login => _login.value;
}
