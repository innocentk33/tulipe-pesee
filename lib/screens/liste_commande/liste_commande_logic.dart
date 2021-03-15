import 'package:fish_scan/constants/status_commande_constants.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/repository/commande_repository.dart';
import 'package:fish_scan/repository/tracabilite_repository.dart';
import 'package:fish_scan/utils/get_storage_service.dart';
import 'package:get/get.dart';

import '../../constants/navigation_menu.dart';

class ListeCommandeController extends GetxController {
  var _isLoading = false.obs;
  ApiResponse<Commande> _response;

  CommandeRepository commandeRepository = CommandeRepositoryImpl();
  TracabiliteRepository tracabiliteRepository = TracabiliteRepositoryImpl();

  Future<ApiResponse<Commande>> getCommandes(
      NavigationMenu menu, String statusCommande) async {
    _isLoading.value = true;
    _response = await (menu == NavigationMenu.DEPOTAGE
        ? commandeRepository.getCommandesAchat(statusCommande)
        : commandeRepository.getCommandesVente(statusCommande));
    _isLoading.value = false;
    return _response;
  }

  Future<ApiResponse> updateCommandeStatus(
      {Commande commande, int status}) async {
    String login = await GetStorageService.getLogin();
    return tracabiliteRepository.updateCommandeStatus(
        commande: commande, login: login, status: status);
  }

  String getStatusValue(NavigationMenu menu) {
    switch (menu) {
      case NavigationMenu.VENTE_DEMANDE_PREPARATION:
        return StatusCommandeConstants.DEMANDE_PREPARATION;
      case NavigationMenu.VENTE_EN_COURS_PREPARATION:
        return StatusCommandeConstants.EN_COURS_PREPARATION;
      case NavigationMenu.VENTE_CONFIRMATION:
        return StatusCommandeConstants.CONFIRMATION;
      case NavigationMenu.DEPOTAGE:
        return StatusCommandeConstants.DEPOTAGE;
      default:
        return "";
    }
  }

  String getStatusLabel(NavigationMenu menu) {
    switch (menu) {
      case NavigationMenu.VENTE_DEMANDE_PREPARATION:
        return "Demande de préparation";
      case NavigationMenu.VENTE_CONFIRMATION:
        return "Confirmation";
      case NavigationMenu.VENTE_EN_COURS_PREPARATION:
        return "En cours de préparation";
      default:
        return "";
    }
  }

  bool get isLoading => _isLoading.value;

  ApiResponse<Commande> get response => _response;
}
