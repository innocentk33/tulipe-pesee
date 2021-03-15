import 'dart:collection';

import 'package:fish_scan/constants/navigation_menu.dart';
import 'package:fish_scan/database/database_provider.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/tracabilite.dart';
import 'package:fish_scan/repository/article_repository.dart';
import 'package:fish_scan/repository/tracabilite_repository.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DepotageController extends GetxController {
  RxString _barCode = "".obs;
  var dateFormat = DateFormat("yyyy-MM-dd");
  RxBool _clearFields = false.obs;
  RxBool _isPoidsUnique = false.obs;

  TracabiliteRepository tracabiliteRepository = TracabiliteRepositoryImpl();
  ArticleRepository articleRepository = ArticleRepositoryImpl();
  DatabaseProvider databaseProvider = DatabaseProvider();

  ApiResponse<Tracabilite> _response;
  Article _article;

  List<Tracabilite> _tracabilites = [];

  String _userLogin;

  NavigationMenu _menu;

  setArticle(Article article) {
    _article = article;
    update();
  }

  updatePoidsUnique(bool value) {
    _isPoidsUnique.value = value;
    if (value) {
      _clearFields.value = true;
    }
  }

  Future<ApiResponse<Tracabilite>> submitTracabilite(
      NavigationMenu menu) async {
    _response = await tracabiliteRepository.submitTracabilite(
        _tracabilites,
        menu == NavigationMenu.DEPOTAGE ? 39 : 83,
        menu == NavigationMenu.DEPOTAGE ? 1 : 0);
    deleteTracabiliteToDatabase(_response.items);
    return _response;
  }

  Future<ApiResponse<Tracabilite>> getTracabilites() async {
    getTracabiliteFromDatabase();
    return response;
  }

  Future<bool> saveTracabilite(
      {String lot, String quantity, String palette}) async {
    await getUserLogin();

    bool isSaved = await _saveTracabiliteToDatabase(lot, quantity, palette);

    _clearFields.value = false;

    if (isSaved) {
      refreshTracabiliteList();
    }

    return isSaved;
  }

  Future<bool> _saveTracabiliteToDatabase(
      String lot, String quantity, String palette) async {
    await getUserLogin();

    Tracabilite tracabilite = Tracabilite(
      idTracabilite: "${lot.trim()}_${_article.no}",
      sourceID:
          _menu == NavigationMenu.DEPOTAGE ? _article.documentNo : 'ARTICLE',
      itemNoa46: _article.no,
      sourceRefa46Noa46: _article.lineNo,
      lotNoa46: lot,
      quantity: quantity,
      locationCode: _article.locationCode,
      numPalette: palette,
      createdBy: _userLogin,
    );

    var result = await databaseProvider.insertTracabilite(tracabilite);
    print("insert $result");
    if (result.id == -1) {
      return false;
    }

    return true;
  }

  void refreshTracabiliteList() {
    _barCode.value = "";
    _clearFields.value = true;
    getTracabiliteFromDatabase();
    update();
  }

  Future<bool> saveTracabilites(
      {int number, String quantity, String palette}) async {
    await getUserLogin();

    _clearFields.value = false;

    for (int i = 1; i <= number; i++) {
      print("for loop $i");
      await saveTracabilite(
          lot:
              "${_article.documentNo}${_userLogin.substring(0, 2)}${palette}P${i}",
          palette: palette,
          quantity: quantity);
    }

    refreshTracabiliteList();

    return true;
  }

  getTracabiliteFromDatabase() async {
    _tracabilites = await databaseProvider.getTracabiliteByArticle(_article.no);
    update();
  }

  deleteTracabiliteToDatabase(List<Tracabilite> tracabilites) async {
    print("delete");
    _clearFields.value = false;
    await databaseProvider.deleteTracabilites(tracabilites);
    _clearFields.value = true;
    getTracabiliteFromDatabase();
  }

  Future<bool> getBarCode() async {
    _clearFields.value = false;

    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    _barCode.value = barcodeScanRes == "-1" ? "" : barcodeScanRes;

    return barcodeScanRes != "-1" && barcodeScanRes.isNotEmpty;
  }

  String get barCode => _barCode.value;

  ApiResponse get response => _response;

  bool get clearFields => _clearFields.value;

  bool get isPoidsUnique => _isPoidsUnique.value;

  int get nombreCartons => _tracabilites == null ? 0 : _tracabilites.length;

  int get nombreCartonsDemandes =>
      _article == null ? 0 : _article.nombreDeCartons;

  double get poidsDemandes => _article == null ? 0 : _article.quantity;

  double get poidsTotal => _tracabilites.fold(
      0,
      (previousValue, element) =>
          previousValue + double.parse(element.quantity));

  UnmodifiableListView<Tracabilite> get tracabilites =>
      UnmodifiableListView(_tracabilites);

  @override
  void onClose() {
    databaseProvider.close();
    super.onClose();
  }

  Future<ApiResponse<Article>> getNombreColisPeseur(
      {int champs, String sourceType}) async {
    String login = await GetStorageService.getLogin();
    var response = await articleRepository.getNombreColisPeseur(
        article: _article,
        champs: champs,
        sourceType: sourceType,
        login: login);
    return response;
  }

  deleAllTracabilites() async {
    deleteTracabiliteToDatabase(_tracabilites);
  }

  getUserLogin() async {
    _userLogin ??= await GetStorageService.getLogin();
  }

  void setMenu(NavigationMenu menu) {
    this._menu = menu;
  }
}
