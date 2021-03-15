import 'package:fish_scan/api/commande_client.dart';
import 'package:fish_scan/api/soap_client.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:http/http.dart' as http;

abstract class CommandeRepository {
  Future<ApiResponse<Commande>> getCommandesAchat(String statusCommande);
  Future<ApiResponse<Commande>> getCommandesVente(String statusCommande);
  Future<ApiResponse<Commande>> getNombreCommandeParTraitement(int codeTraitement);
}

class CommandeRepositoryImpl extends CommandeRepository {
  final CommandeClient client = CommandeClient();

  @override
  Future<ApiResponse<Commande>> getCommandesAchat(String statusCommande) => client.getCommandesAchat(statusCommande);

  @override
  Future<ApiResponse<Commande>> getCommandesVente(String statusCommande) => client.getCommandesVente(statusCommande);

  @override
  Future<ApiResponse<Commande>> getNombreCommandeParTraitement(int codeTraitement) => client.getNombreCommandeParTraitement(codeTraitement);
}
