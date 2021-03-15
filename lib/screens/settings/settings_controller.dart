import 'package:fish_scan/models/parametre.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  Future<bool> saveSettings(
      {String serveur, String port, String instance, String societe}) async {
    await GetStorageService.saveParametre(Parametre(
        serveur: serveur, port: port, instance: instance, societe: societe));
    return true;
  }

  Future<Parametre> getParametre() => GetStorageService.getParametre();
}
