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

class VenteDashboardController extends GetxController {
  CommandeRepository repository = CommandeRepositoryImpl();

  RxInt _nombre = 0.obs;
  RxBool _isLoading = false.obs;

  getNombreCommandeParTraitement(int codeTraitement) async {
    _isLoading.value = true;
    var response =
        await repository.getNombreCommandeParTraitement(codeTraitement);
    if (!response.hasError) {
      _isLoading.value = false;
      _nombre.value = int.parse(response.body);
    }
  }

  int get nombre => _nombre.value;
  bool get isLoading => _isLoading.value;
}
