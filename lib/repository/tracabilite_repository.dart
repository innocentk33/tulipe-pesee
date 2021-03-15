import 'package:fish_scan/api/article_client.dart';
import 'package:fish_scan/api/commande_client.dart';
import 'package:fish_scan/api/soap_client.dart';
import 'package:fish_scan/api/tracabilite_client.dart';
import 'package:fish_scan/models/api_response.dart';
import 'package:fish_scan/models/article.dart';
import 'package:fish_scan/models/commande.dart';
import 'package:fish_scan/models/pesee.dart';
import 'package:fish_scan/models/tracabilite.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

abstract class TracabiliteRepository {
  Future<ApiResponse<Tracabilite>> submitTracabilite(
      List<Tracabilite> tracabilites, int sourceType, int sourceSubType);

  Future<ApiResponse<Pesee>> submitPesee(List<Pesee> pesees);

  Future<ApiResponse<Pesee>> submitPeseeManuelle(List<Pesee> pesees);

  Future<ApiResponse<Pesee>> deletePesees(Pesee pesee);

  Future<ApiResponse<Pesee>> deletePeseesManuelle(Pesee pesee);

  Future<ApiResponse> updateCommandeQuantity(
      Article article, double quantity, int nombreCartons);

  Future<ApiResponse> updateCommandeStatus(
      {Commande commande, String login, int status});

  Future<ApiResponse<Pesee>> getPesee(Article article);

  Future<ApiResponse<Pesee>> getPeseeManuelle(Article article);

  Future<ApiResponse<Tracabilite>> getTracabilite(Article article);

  Future<ApiResponse> deleteTracabilite(
      {String articleNo, String commandeNo, String sourceType});
}

class TracabiliteRepositoryImpl extends TracabiliteRepository {
  final TracabiliteClient client = TracabiliteClient();

  @override
  Future<ApiResponse<Tracabilite>> submitTracabilite(
      List<Tracabilite> tracabilites, int sourceType, int sourceSubType) async {
    var dateFormat = DateFormat("yyyy-MM-dd");
    var currentDate = dateFormat.format(DateTime.now());

    int totalTracabilites = tracabilites.length;
    int nbreTracabilitesSend = 0;

    List<Future<ApiResponse<Tracabilite>>> apiRequests = [];

    tracabilites.forEach((tracabilite) {
      tracabilite.creationDate = currentDate;
      tracabilite.expectedReceiptDate = currentDate;
      apiRequests.add(
          client.submitTracabilite(tracabilite, sourceType, sourceSubType));
    });

    List<ApiResponse<Tracabilite>> apiResults =
        await Future.wait<ApiResponse<Tracabilite>>(apiRequests);

    List<ApiResponse<Tracabilite>> succeedeedApiResults =
        apiResults.where((element) => !element.hasError).toList();

    nbreTracabilitesSend = succeedeedApiResults.length;

    List<Tracabilite> tracabilitesToReturn = [];
    if (succeedeedApiResults.isNotEmpty) {
      tracabilitesToReturn =
          succeedeedApiResults.map((response) => response.items.first).toList();
    }

    return ApiResponse<Tracabilite>(
        hasError: nbreTracabilitesSend == totalTracabilites ? false : true,
        message:
            "Traitement terminé !\n$nbreTracabilitesSend/$totalTracabilites donnée(s) envoyée(s)",
        items: tracabilitesToReturn);
  }

  @override
  Future<ApiResponse<Pesee>> submitPesee(List<Pesee> pesees) async {
    var dateFormat = DateFormat("yyyy-MM-dd");
    var currentDate = dateFormat.format(DateTime.now());

    var totalPesees = pesees.length;
    var nbrePeseeSend = 0;

    List<Future<ApiResponse<Pesee>>> apiRequests = [];

    pesees.forEach((pesee) {
      pesee.creationDate = currentDate;
      pesee.expectedReceiptDate = currentDate;
      apiRequests.add(client.submitPesee(pesee));
    });

    List<ApiResponse<Pesee>> apiResults =
        await Future.wait<ApiResponse<Pesee>>(apiRequests);
    List<ApiResponse<Pesee>> succeedeedApiResults =
        apiResults.where((element) => !element.hasError).toList();
    nbrePeseeSend = succeedeedApiResults.length;

    List<Pesee> peseesToReturn = [];
    if (succeedeedApiResults.isNotEmpty) {
      peseesToReturn =
          succeedeedApiResults.map((response) => response.items.first).toList();
    }

    return ApiResponse<Pesee>(
        hasError: nbrePeseeSend == totalPesees ? false : true,
        message:
            "Traitement terminé !\n$nbrePeseeSend/$totalPesees donnée(s) envoyée(s)",
        items: peseesToReturn);
  }

  @override
  Future<ApiResponse> updateCommandeQuantity(
          Article article, double quantity, int nombreCartons) =>
      client.updateCommandeQuantity(article, quantity, nombreCartons);

  @override
  Future<ApiResponse> updateCommandeStatus(
          {Commande commande, String login, int status}) =>
      client.updateCommandeStatus(
          commande: commande, login: login, status: status);

  @override
  Future<ApiResponse<Pesee>> getPesee(Article article) =>
      client.getPesee(article);

  @override
  Future<ApiResponse> deleteTracabilite(
          {String articleNo, String commandeNo, String sourceType}) =>
      client.deleteTracabilite(
          articleNo: articleNo, commandeNo: commandeNo, sourceType: sourceType);

  @override
  Future<ApiResponse<Tracabilite>> getTracabilite(Article article) =>
      client.getTracabilite(article);

  @override
  Future<ApiResponse<Pesee>> deletePesees(Pesee pesee) =>
      client.deletePesee(pesee);

  @override
  Future<ApiResponse<Pesee>> getPeseeManuelle(Article article) => client.getPeseeManuelle(article);

  @override
  Future<ApiResponse<Pesee>> submitPeseeManuelle(List<Pesee> pesees) async{
    var dateFormat = DateFormat("yyyy-MM-dd");
    var currentDate = dateFormat.format(DateTime.now());

    var totalPesees = pesees.length;
    var nbrePeseeSend = 0;

    List<Future<ApiResponse<Pesee>>> apiRequests = [];

    pesees.forEach((pesee) {
      pesee.creationDate = currentDate;
      pesee.expectedReceiptDate = currentDate;
      apiRequests.add(client.submitPeseeManuelle(pesee));
    });

    List<ApiResponse<Pesee>> apiResults =
        await Future.wait<ApiResponse<Pesee>>(apiRequests);
    List<ApiResponse<Pesee>> succeedeedApiResults =
    apiResults.where((element) => !element.hasError).toList();
    nbrePeseeSend = succeedeedApiResults.length;

    List<Pesee> peseesToReturn = [];
    if (succeedeedApiResults.isNotEmpty) {
      peseesToReturn =
          succeedeedApiResults.map((response) => response.items.first).toList();
    }

    return ApiResponse<Pesee>(
        hasError: nbrePeseeSend == totalPesees ? false : true,
        message:
        "Traitement terminé !\n$nbrePeseeSend/$totalPesees donnée(s) envoyée(s)",
        items: peseesToReturn);
  }

  @override
  Future<ApiResponse<Pesee>> deletePeseesManuelle(Pesee pesee)  => client.deletePeseesManuelle(pesee);
}
