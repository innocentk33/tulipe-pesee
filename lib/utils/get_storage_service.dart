import 'dart:convert';

import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/parametre.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStorageService {

  static String _userInfoKey = "userInfoKey";
  static String _parametreKey = "parametreKey";
  static String _urlKey = "urlKey";

  static GetStorage _getStorage = GetStorage();

  static saveLogin(String login) async {
    _getStorage.write(_userInfoKey, login);
  }

  static Future<String> getLogin() async {
    var data = await _getStorage.read(_userInfoKey);
    return data;
  }

  static saveParametre(Parametre parametre) async {
    await saveUrl(parametre);
    _getStorage.write(_parametreKey, jsonEncode(parametre.toJson()));
  }

  static Future<Parametre> getParametre() async {
    var data = await _getStorage.read(_parametreKey);
    if (data == null) return data;
    return Parametre.fromJson(jsonDecode(data));
  }

  static Future<Parametre> clearUserLogin() async {
    await _getStorage.remove(_userInfoKey);
  }


  static Future clearAll() async {
    _getStorage.erase();
  }

  static Future saveUrl(Parametre parametre) {
    _getStorage.write(_urlKey,
        "${parametre.serveur}:${parametre.port}/${parametre
            .instance}/WS/${parametre.societe}");
  }

  static Future<String> getUrl() async {
    var data = await _getStorage.read(_urlKey);
    return data;
  }
}
