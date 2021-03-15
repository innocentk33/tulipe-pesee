import 'dart:collection';

import 'package:fish_scan/database/database_provider.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/models/pesee.dart';
import 'package:fish_scan/repository/article_repository.dart';
import 'package:fish_scan/repository/commande_repository.dart';
import 'package:fish_scan/repository/tracabilite_repository.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VentePeseeManuelleController extends GetxController {
  var _barCode = "".obs;
  var _quantity = "".obs;
  var dateFormat = DateFormat("yyyy-MM-dd");
  var _clearFields = false.obs;
  var _isLoadingSubmit = false.obs;
  RxBool _isPoidsUnique = false.obs;

  TracabiliteRepository tracabiliteRepository = TracabiliteRepositoryImpl();
  ArticleRepository articleRepository = ArticleRepositoryImpl();
  DatabaseProvider databaseProvider = DatabaseProvider();

  ApiResponse _response;
  Article _article;

  List<Pesee> _pesees = [];

  String userLogin;

  setArticle(Article article) {
    _article = article;
  }

  Future<ApiResponse> submitPesee() async {
    var responseDelete =
        await tracabiliteRepository.deletePeseesManuelle(_pesees.first);
    if (responseDelete.hasError) {
      return responseDelete;
    }
    return sendPesee();
  }

  Future<ApiResponse<Pesee>> getPesees() async {
    var response = await tracabiliteRepository.getPeseeManuelle(_article);
    _pesees.addAll(response.items);
    for (int i = 0; i < _pesees.length; i++) {
      await databaseProvider.insertPesee(_pesees[i]);
    }
    update();
    return response;
  }

  Future<ApiResponse> sendPesee() async {
    _response = await tracabiliteRepository.submitPeseeManuelle(_pesees);
    deletePeseeToDatabase(_response.items);
    return _response;
  }

  Future<ApiResponse> updateCommandeStatus() async {
    String login = await GetStorageService.getLogin();
    return tracabiliteRepository.updateCommandeStatus(
        commande: Commande(no: _article.documentNo), login: login, status: 3);
  }

  Future<bool> savePeseeToDatabase({String lot, String quantity}) async {
    var userLogin = await GetStorageService.getLogin();

    Pesee pesee = Pesee(
      idPesee: "${lot}_${quantity}_${_article.no}",
      lotNoa46: lot,
      quantity: quantity,
      articleNo: _article.no,
      locationCode: _article.locationCode,
      sourceID: _article.documentNo,
      itemNoa46: _article.no,
      sourceRefa46Noa46: _article.lineNo,
      createdBy: userLogin,
      isPreparateur: _article.preparateur == userLogin,
      isVerificateur: _article.verificateur == userLogin,
    );

    _clearFields.value = false;
    var result = await databaseProvider.insertPesee(pesee);
    if (result.id == -1) {
      return false;
    }

    _pesees.add(result);
    resetFields();
    update();
    return true;
  }

  void resetFields() {
    _barCode.value = "";
    _quantity.value = "";
    _clearFields.value = true;
  }

  getPeseeFromDatabase() async {
    _pesees = await databaseProvider.getPeseeByArticle(_article.no);
    update();
  }

  deletePeseeToDatabase(List<Pesee> pesees) async {
    _clearFields.value = false;
    for (int i = 0; i < pesees.length; i++) {
      await databaseProvider.deletePesee(pesees[i].idPesee);
    }
    resetFields();
    getPeseeFromDatabase();
  }

  deleteAllPesees() async {
    deletePeseeToDatabase(_pesees);
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

  Future<ApiResponse<Article>> searchArticle(
      {String lot, String quantity, String userLogin}) async {
    ApiResponse<Article> response;
    if (!isPoidsUnique) {
      response = await articleRepository.getArticlesVenteByLot(
          articleNo: _article.no,
          lot: lot.trim(),
          locationCode: _article.locationCode);
      if (!response.hasError) {
        _quantity.value = response.items.first.quantity.toString();
      }
    } else {
      userLogin ??= await GetStorageService.getLogin();

      response = await articleRepository.getFreeLotNo(
          number: int.parse(lot.trim()),
          quantity: quantity,
          article: _article,
          userLogin: userLogin);
    }

    return response;
  }

  Future openDatabase() async {
    await databaseProvider.open();
  }

  String get barCode => _barCode.value;

  String get quantity => _quantity.value;

  ApiResponse get response => _response;

  bool get clearFields => _clearFields.value;

  bool get isLoadingSubmit => _isLoadingSubmit.value;

  int get nombreCartons => _pesees == null ? 0 : _pesees.length;
 // int get nbrCartons =>

  int get nombreCartonsDemandes =>
      _article == null ? 0 : _article.nombreDeCartons;

  double get poidsDemandes => _article == null ? 0: _article.quantityBase;

  bool get isPoidsUnique => _isPoidsUnique.value;

  double get poidsTotal => _pesees.fold(
      0,
      (previousValue, element) =>
          previousValue + double.parse(element.quantity));

  UnmodifiableListView<Pesee> get pesees => UnmodifiableListView(_pesees);

  updatePoidsUnique(bool value) {
    _isPoidsUnique.value = value;
  }

  Future deleteRemotePesee() async {
    if (_pesees.isNotEmpty) {
      for (int i = 0; i < _pesees.length; i++) {
        var pesee = _pesees[i];
        tracabiliteRepository.deletePeseesManuelle(pesee).then((value) => null);
      }
      return ApiResponse(hasError: false, message: "Suppression reussie");
    }

    return ApiResponse(hasError: true, message: "Aucun élément à supprimer");
  }
}
