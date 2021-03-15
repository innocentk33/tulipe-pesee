import 'package:fish_scan/models/parametre.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SplashScreenController extends GetxController{

  Future<String> getUserLogin() => GetStorageService.getLogin();
  Future<Parametre> getParametre() => GetStorageService.getParametre();
}