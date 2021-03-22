import 'package:fish_scan/api/commande_client.dart';
import 'package:fish_scan/api/commande_manuelle_client.dart';
import 'package:fish_scan/api/soap_client.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:http/http.dart' as http;

abstract class CommandeManuelleRepository {
  Future<ApiResponse<Commande>> getCommande(String statusCommande);
  Future<ApiResponse<Commande>> updateNomPeseur(String noCommande);
  Future<ApiResponse<Commande>> updateNomVerificateur(String noCommande);
  Future<ApiResponse<Commande>> validerCommande(String noCommande);
  Future<ApiResponse<Commande>> validerPesee(String noCommande);
  Future<ApiResponse<Commande>> setComLinPeseeActeur(String noCommande , String article);

}

class CommandeManuelleRepositoryImpl extends CommandeManuelleRepository {
  final CommandeManuelleClient client = CommandeManuelleClient();

  @override
  Future<ApiResponse<Commande>> getCommande(String statusCommande) => client.getCommandes(statusCommande);

  @override
  Future<ApiResponse<Commande>> updateNomPeseur(String noCommande) => client.updateNomPeseur(noCommande); @override
  Future<ApiResponse<Commande>> validerCommande(String noCommande) => client.validerCommande(noCommande);

  @override
  Future<ApiResponse<Commande>> setComLinPeseeActeur(String noCommande ,String article) => client.setComLinPeseeActeur(noCommande ,article);

  @override
  Future<ApiResponse<Commande>> updateNomVerificateur(String noCommande) => client.updateNomVerificateur(noCommande);

  @override
  Future<ApiResponse<Commande>> validerPesee(String noCommande) => client.validerPesee(noCommande);
}
